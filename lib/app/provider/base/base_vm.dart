// lib/shared/base_viewmodel.dart
import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  // ------------------------- COMMON STATE -------------------------
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isDisposed = false;

  // ------------------------- GETTERS -------------------------
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  bool get isDisposed => _isDisposed;

  // ------------------------- STATE MANAGEMENT -------------------------
  void setLoading(bool loading) {
    if (_isDisposed) return;
    _isLoading = loading;
    _hasError = false;
    _errorMessage = null;
    safeNotifyListeners();
  }

  void setError(String message) {
    if (_isDisposed) return;
    _isLoading = false;
    _hasError = true;
    _errorMessage = message;
    safeNotifyListeners();
  }

  void setSuccess() {
    if (_isDisposed) return;
    _isLoading = false;
    _hasError = false;
    _errorMessage = null;
    safeNotifyListeners();
  }

  void clearError() {
    if (_isDisposed) return;
    _hasError = false;
    _errorMessage = null;
    safeNotifyListeners();
  }

  void resetState() {
    if (_isDisposed) return;
    _isLoading = false;
    _hasError = false;
    _errorMessage = null;
    safeNotifyListeners();
  }

  // ------------------------- SAFE NOTIFICATION -------------------------
  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // ------------------------- API CALL WRAPPER -------------------------
  Future<T> executeApiCall<T>({
    required Future<T> Function() apiCall,
    String? loadingMessage,
    String? errorMessage,
    bool showLoading = true,
    bool showError = true,
  }) async {
    try {
      if (showLoading) setLoading(true);
      
      final result = await apiCall();
      
      if (showLoading) setSuccess();
      return result;
      
    } catch (e) {
      if (showError) {
        setError(errorMessage ?? e.toString());
      } else {
        setSuccess(); // Clear loading state even if we don't show error
      }
      rethrow;
    }
  }

  // ------------------------- FORM VALIDATION -------------------------
  bool validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  // ------------------------- DISPOSE -------------------------
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}