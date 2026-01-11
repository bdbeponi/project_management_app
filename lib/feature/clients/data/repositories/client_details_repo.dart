import 'dart:developer';

import 'package:project_management/feature/clients/data/services/client_api.dart';
import 'package:project_management/feature/clients/model/client_details_response_model.dart';

class ClientDetailsRepository {
  final ClientApi _clientApi;

  // Cache for client details by ID
  final Map<String?, Data> _detailsCache = {};

  ClientDetailsRepository({ClientApi? clientApi})
    : _clientApi = clientApi ?? ClientApi.instance;

  /// Fetch client details by ID
  Future<ClientDetailsResponseModel> getClientDetails({
    required String? clientId,
    bool forceRefresh = false,
  }) async {
    try {
      // Return from cache if available
      if (!forceRefresh && _detailsCache.containsKey(clientId)) {
        log('Returning cached client details for ID: $clientId');
        return ClientDetailsResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache',
          data: _detailsCache[clientId],
        );
      }

      log('Fetching client details from API for ID: $clientId');

      final apiResponse = await _clientApi.getClientDetails(clientId: clientId);

      if (apiResponse.success != true || apiResponse.data == null) {
        throw ClientDetailsFailure(
          apiResponse.message ?? 'Failed to fetch client details',
        );
      }

      final data = apiResponse.data!;

      // Cache the result
      _detailsCache[clientId] = data.data!;

      // Clean cache if needed
      _cleanupCache();

      return apiResponse.data!;
    } catch (e) {
      log('Client details API failed: $e');

      // Return cached version if exists
      if (_detailsCache.containsKey(clientId)) {
        return ClientDetailsResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache (offline)',
          data: _detailsCache[clientId],
        );
      }

      return _handleError(e);
    }
  }

  /// Clear cached client details
  void clearCache({String? clientId}) {
    if (clientId != null) {
      _detailsCache.remove(clientId);
    } else {
      _detailsCache.clear();
    }
  }

  // ================== Helpers ==================

  void _cleanupCache() {
    // Keep cache size reasonable (e.g., max 20 entries)
    if (_detailsCache.length > 20) {
      _detailsCache.remove(_detailsCache.keys.first);
    }
  }

  ClientDetailsResponseModel _handleError(dynamic e) {
    final message = e is ClientDetailsFailure
        ? e.message
        : 'Failed to load client details. Please try again.';

    return ClientDetailsResponseModel(
      statusCode: 500,
      success: false,
      message: message,
      data: null,
    );
  }
}

class ClientDetailsFailure implements Exception {
  final String message;
  ClientDetailsFailure(this.message);

  @override
  String toString() => message;
}
