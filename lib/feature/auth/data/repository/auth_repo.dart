// // lib/feature/auth/repository/auth_repository.dart

// import 'package:project_management/feature/auth/data/service/auth_api.dart';
// import 'package:project_management/feature/auth/model/login_response_model.dart';
// import 'package:project_management/shared/networks/dio/base_api.dart';
// import 'package:project_management/shared/networks/dio/dio.dart';
// import 'package:project_management/shared/networks/endpoints.dart';

// class AuthRepository {
//   final BaseApi _api;

//   // Use dependency injection for testability
//   AuthRepository({BaseApi? api}) : _api = api ?? AuthApi.instance;

//   // ------------------------- LOGIN -------------------------
//   Future<LoginResponseModel> login({
//     required String email,
//     required String password,
//   }) async {
//     final response = await _api.postRequest<LoginResponseModel>(
//       endpoint: Endpoints.login(),
//       data: {"email": email, "password": password},
//       fromJson: LoginResponseModel.fromJson,
//       errorMessage: 'Login failed. Please check your credentials.',
//     );

//     if (response.success && response.data != null) {
//       return response.data!;
//     } else {
//       throw AuthFailure(response.message ?? 'Login failed');
//     }
//   }

//   // ------------------------- LOGOUT -------------------------
//   Future<void> logout() async {
//     // Clear local token/storage
//     DioSingleton.instance.clearAuth();

//     // Call logout API if you have one
//     // final response = await _api.postRequest<void>(
//     //   endpoint: Endpoints.logout(),
//     //   data: {},
//     //   fromJson: (_) => null,
//     //   errorMessage: 'Logout failed',
//     // );
//   }

//   // ------------------------- TOKEN MANAGEMENT -------------------------
//   void saveAuthToken(String token) {
//     DioSingleton.instance.updateAuth(token);
//     // Also save to local storage if needed
//   }

//   void clearAuthToken() {
//     DioSingleton.instance.clearAuth();
//     // Also clear from local storage
//   }

//   bool hasValidToken() {
//     // Check if token exists and is not expired
//     // You might want to store token expiry in your LoginResponseModel
//     return true; // Implement actual check
//   }
// }

// // Simple failure class if you don't have one
// class AuthFailure implements Exception {
//   final String message;
//   AuthFailure(this.message);

//   @override
//   String toString() => 'AuthFailure: $message';
// }

// lib/feature/auth/repository/auth_repository.dart
import 'dart:developer';

import 'package:project_management/db/service/login/login_local_service.dart';
import 'package:project_management/feature/auth/data/service/auth_api.dart';
import 'package:project_management/feature/auth/model/login_response_model.dart';

class AuthRepository {
  final AuthApi _authApi;
  final LoginLocalService _localService;

  AuthRepository({
    AuthApi? authApi,
    LoginLocalService? localService,
  })  : _authApi = authApi ?? AuthApi.instance,
        _localService = localService ?? LoginLocalService();

  /// Initialize the repository
  Future<void> init() async {
    await _localService.init();
  }

  /// Login with email and password
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Call API
      final response = await _authApi.login(
        email: email,
        password: password,
      );

      // Check response
      if (!response.success || response.data == null) {
        throw AuthFailure(response.message ?? 'Login failed');
      }

      final loginData = response.data!;

      // Save to local storage
      await _localService.saveLoginData(loginData);

      return loginData;
    } catch (e) {
      // Simplify error handling
      final errorMessage = e.toString();
      
      if (errorMessage.contains('timeout')) {
        throw AuthFailure('Connection timeout. Check your internet.');
      } else if (errorMessage.contains('400') || errorMessage.contains('401')) {
        throw AuthFailure('Invalid email or password');
      } else if (errorMessage.contains('500')) {
        throw AuthFailure('Server error. Try again later.');
      } else {
        throw AuthFailure('Login failed. Please try again.');
      }
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      await init();
      return _localService.isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    try {
      await init();
      return _localService.accessToken;
    } catch (e) {
      return null;
    }
  }

  /// Get stored user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      await init();
      return _localService.userProfile;
    } catch (e) {
      return null;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await init();
      await _localService.clearLoginData();
    } catch (e) {
      // Even if clearing fails, we still consider logout successful
      log('Logout error: $e');
    }
  }

  /// Update user profile locally
  Future<void> updateProfile({
    String? userName,
    String? email,
    String? image,
  }) async {
    try {
      await init();
      await _localService.updateUserProfile(
        userName: userName,
        email: email,
        image: image,
      );
    } catch (e) {
      log('Profile update failed: $e');
    }
  }

  /// Get user display name
  Future<String> getDisplayName() async {
    try {
      await init();
      return _localService.displayName;
    } catch (e) {
      return 'Guest';
    }
  }

  /// Check if user has admin role
  Future<bool> isAdmin() async {
    try {
      await init();
      return _localService.isAdmin;
    } catch (e) {
      return false;
    }
  }
}

class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);

  @override
  String toString() => message;
}