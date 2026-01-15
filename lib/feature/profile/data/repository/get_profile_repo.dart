import 'dart:developer';

import 'package:project_management/feature/profile/data/service/get_profile_api.dart';
import 'package:project_management/feature/profile/model/get_user_profile_response_model.dart';

/// Repository responsible for handling user profile data
class ProfileRepository {
  final GetProfileApi _profileApi;

  // Cache
  Data? _cachedProfile;
  DateTime? _lastFetchedAt;

  ProfileRepository({GetProfileApi? profileApi})
    : _profileApi = profileApi ?? GetProfileApi.instance;

  /// Fetch user profile
  Future<GetUserProfileResponseModel> getUserProfile({
    bool refreshCache = false,
  }) async {
    try {
      // Return cached profile if available and not forced to refresh
      if (!refreshCache && _cachedProfile != null) {
        log('Returning cached user profile');
        return GetUserProfileResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache',
          data: _cachedProfile,
        );
      }

      log('Fetching user profile from API');
      final response = await _profileApi.getInvoiceList();

      if (!response.success) {
        throw ProfileFailure(
          response.message ?? 'Failed to fetch user profile',
        );
      }

      final profileData = response.data;
      if (profileData == null) {
        throw ProfileFailure('No profile data received from server');
      }

      // Cache profile
      _cachedProfile = profileData.data;
      _lastFetchedAt = DateTime.now();

      return profileData;
    } catch (e) {
      // Fallback to cache if available
      if (_cachedProfile != null) {
        log('API failed, returning cached profile: $e');
        return GetUserProfileResponseModel(
          statusCode: 200,
          success: true,
          message: 'Loaded from cache (offline)',
          data: _cachedProfile,
        );
      }

      return _handleError(e);
    }
  }

  /// Force refresh profile
  Future<GetUserProfileResponseModel> refreshProfile() async {
    return getUserProfile(refreshCache: true);
  }

  /// Get cached profile directly
  Data? getCachedProfile() {
    return _cachedProfile;
  }

  /// Get last fetch time
  DateTime? getLastFetchedTime() {
    return _lastFetchedAt;
  }

  /// Clear cached profile
  void clearCache() {
    _cachedProfile = null;
    _lastFetchedAt = null;
  }

  /// Check if profile is cached
  bool hasCachedProfile() {
    return _cachedProfile != null;
  }

  /// Private error handler (aligned with InvoiceRepository)
  GetUserProfileResponseModel _handleError(dynamic e) {
    String errorMessage;

    if (e is ProfileFailure) {
      errorMessage = e.message;
    } else {
      final errorString = e.toString();

      if (errorString.contains('timeout') ||
          errorString.contains('SocketException')) {
        errorMessage = 'Connection timeout. Check your internet.';
      } else if (errorString.contains('401') || errorString.contains('403')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (errorString.contains('404')) {
        errorMessage = 'User profile not found.';
      } else if (errorString.contains('500')) {
        errorMessage = 'Server error. Try again later.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
    }

    return GetUserProfileResponseModel(
      statusCode: 500,
      success: false,
      message: errorMessage,
      data: null,
    );
  }
}

/// Custom failure class (same pattern as InvoiceFailure)
class ProfileFailure implements Exception {
  final String message;
  ProfileFailure(this.message);

  @override
  String toString() => message;
}
