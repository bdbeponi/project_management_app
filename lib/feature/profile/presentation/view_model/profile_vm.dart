import 'package:flutter/foundation.dart';
import 'package:project_management/feature/profile/data/repository/get_profile_repo.dart';
import 'package:project_management/feature/profile/model/get_user_profile_response_model.dart';

/// ViewModel for User Profile
class ProfileVm extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileVm({ProfileRepository? repository})
    : _repository = repository ?? ProfileRepository();

  // UI State
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _errorMessage;

  // Data
  Data? _profile;

  /// Getters
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;
  Data? get profile => _profile;
  bool get hasProfile => _profile != null;

  /// Initial load (call from initState)
  Future<void> loadProfile() async {
    _setLoading(true);
    _errorMessage = null;

    final response = await _repository.getUserProfile();

    if (response.success == true) {
      _profile = response.data;
    } else {
      _errorMessage = response.message ?? 'Failed to load profile';
    }

    _setLoading(false);
  }

  /// Pull-to-refresh / manual refresh
  Future<void> refreshProfile() async {
    _isRefreshing = true;
    notifyListeners();

    final response = await _repository.refreshProfile();

    if (response.success == true) {
      _profile = response.data;
      _errorMessage = null;
    } else {
      _errorMessage = response.message ?? 'Failed to refresh profile';
    }

    _isRefreshing = false;
    notifyListeners();
  }

  /// Force reload and clear cache
  Future<void> reloadProfile() async {
    _repository.clearCache();
    await loadProfile();
  }

  /// Clear local error (useful after showing snackbar)
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear profile data (e.g. on logout)
  void clearProfile() {
    _repository.clearCache();
    _profile = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Private loading handler
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
