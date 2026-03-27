import 'dart:developer';

import 'package:project_management/feature/clients/data/services/client_api.dart';
import 'package:project_management/feature/clients/model/client_list_response_model.dart';

class ClientRepository {
  final ClientApi _clientApi;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _pageSize = 10;

  String _currentSearch = '';  
  String _currentOrderBy = 'desc';
  String? _currentRole;
  String? _currentStatus;
 
  // Cache
  final Map<String, List<Item>> _searchCache = {};

  ClientRepository({ClientApi? clientApi})
    : _clientApi = clientApi ?? ClientApi.instance;

  /// Fetch clients with pagination
  Future<ClientListResponseModel> getClients({
    int page = 1,
    int pageSize = 10,
    String search = '',
    String orderBy = 'desc',
    String? role,
    String? status,
    bool forceRefresh = false,
  }) async {
    try {
      _currentPage = page;
      _pageSize = pageSize;
      _currentSearch = search;
      _currentOrderBy = orderBy;
      _currentRole = role;
      _currentStatus = status;

      final cacheKey = _cacheKey(
        page: page,
        search: search,
        orderBy: orderBy,
        role: role,
        status: status,
      );

      // Serve from cache
      if (!forceRefresh && _searchCache.containsKey(cacheKey)) {
        log('Returning cached clients');

        return _buildCachedResponse(items: _searchCache[cacheKey]!, page: page);
      }

      log('Fetching clients from API');

      final apiResponse = await _clientApi.getClientList(
        page: page,
        perPage: pageSize,
        search: search,
        orderBy: orderBy,
        role: role,
        status: status,
      );

      if (apiResponse.success != true || apiResponse.data == null) {
        throw ClientFailure(apiResponse.message ?? 'Failed to fetch clients');
      }

      final data = apiResponse.data!;

      // Update pagination
      if (data.data?.meta != null) {
        _totalPages = data.data?.meta!.lastPage ?? 1;
        _totalItems = data.data?.meta!.total ?? 0;
      } else {
        _totalPages = 1;
        _totalItems = data.data?.items?.length ?? 0;
      }

      // Cache
      if (data.data?.items != null) {
        _searchCache[cacheKey] = data.data!.items!;
        _cleanupCache();
      }

      return apiResponse.data!;
    } catch (e) {
      log('Client API failed: $e');

      final cacheKey = _cacheKey(
        page: page,
        search: search,
        orderBy: orderBy,
        role: role,
        status: status,
      );

      if (_searchCache.containsKey(cacheKey)) {
        return _buildCachedResponse(
          items: _searchCache[cacheKey]!,
          page: page,
          offline: true,
        );
      }

      return _handleError(e);
    }
  }

  /// Load next page
  Future<ClientListResponseModel> loadNextPage() {
    if (_currentPage >= _totalPages) {
      return Future.value(_noMorePages());
    }

    return getClients(
      page: _currentPage + 1,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      role: _currentRole,
      status: _currentStatus,
    );
  }

  /// Refresh current page
  Future<ClientListResponseModel> refresh() {
    return getClients(
      page: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
      orderBy: _currentOrderBy,
      role: _currentRole,
      status: _currentStatus,
      forceRefresh: true,
    );
  }

  /// Search clients
  Future<ClientListResponseModel> searchClients(String query) {
    _searchCache.clear();

    return getClients(
      page: 1,
      pageSize: _pageSize,
      search: query,
      orderBy: _currentOrderBy,
      role: _currentRole,
      status: _currentStatus,
    );
  }

  /// Get cached client by ID
  Item? getClientById(String id) {
    for (final items in _searchCache.values) {
      for (final item in items) {
        if (item.id == id) return item;
      }
    }
    return null;
  }

  /// Pagination info
  Map<String, dynamic> getPaginationInfo() => {
    'currentPage': _currentPage,
    'totalPages': _totalPages,
    'totalItems': _totalItems,
    'pageSize': _pageSize,
    'hasMore': _currentPage < _totalPages,
  };

  // ================== Helpers ==================

  String _cacheKey({
    required int page,
    required String search,
    required String orderBy,
    String? role,
    String? status,
  }) => '${page}_${search}_${orderBy}_${role ?? ''}_${status ?? ''}';

  void _cleanupCache() {
    if (_searchCache.length > 10) {
      _searchCache.remove(_searchCache.keys.first);
    }
  }

  ClientListResponseModel _buildCachedResponse({
    required List<Item> items,
    required int page,
    bool offline = false,
  }) {
    return ClientListResponseModel(
      statusCode: 200,
      success: true,
      message: offline ? 'Loaded from cache (offline)' : 'Loaded from cache',
      data: Data(
        items: items,
        meta: Meta(
          currentPage: page,
          from: ((page - 1) * _pageSize) + 1,
          lastPage: _totalPages,
          perPage: _pageSize,
          to: page * _pageSize,
          total: _totalItems,
        ),
      ),
    );
  }

  ClientListResponseModel _noMorePages() {
    return ClientListResponseModel(
      statusCode: 400,
      success: false,
      message: 'No more pages available',
      data: null,
    );
  }

  ClientListResponseModel _handleError(dynamic e) {
    final message = e is ClientFailure
        ? e.message
        : 'Failed to load clients. Please try again.';

    return ClientListResponseModel(
      statusCode: 500,
      success: false,
      message: message,
      data: null,
    );
  }
}

class ClientFailure implements Exception {
  final String message;
  ClientFailure(this.message);

  @override
  String toString() => message;
}
