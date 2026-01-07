import 'dart:developer';

import 'package:project_management/feature/auth/model/login_response_model.dart';
import 'package:project_management/shared/networks/dio/base_api.dart';
import 'package:project_management/shared/networks/dio/dio.dart';
import 'package:project_management/shared/networks/endpoints.dart';

final class AuthApi extends BaseApi {
  AuthApi._internal();
  static final AuthApi _singleton = AuthApi._internal();
  static AuthApi get instance => _singleton;

  /// Login with email and password
  Future<ApiResponse<LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    log("message");
    return postRequest<LoginResponseModel>(
      endpoint: Endpoints.login(),
      data: {
        "userEmail": "admin@gmail.com",
        "userPass": "12345678",
        "rememberMe": true,
      },
      fromJson: LoginResponseModel.fromJson,
      errorMessage: 'Login failed. Please check your credentials.',
    );
  }

  // /// Logout user
  // Future<ApiResponse<void>> logout() async {
  //   return postRequest<void>(
  //     endpoint: Endpoints.logout(),
  //     data: {},
  //     fromJson: (_) {}, // No response data expected
  //     errorMessage: 'Logout failed. Please try again.',
  //   );
  // }

  // /// Refresh access token
  // Future<ApiResponse<LoginResponseModel>> refreshToken({
  //   required String refreshToken,
  // }) async {
  //   return postRequest<LoginResponseModel>(
  //     endpoint: Endpoints.refreshToken(),
  //     data: {"refresh_token": refreshToken},
  //     fromJson: LoginResponseModel.fromJson,
  //     errorMessage: 'Failed to refresh token. Please login again.',
  //   );
  // }

  /// Verify user account
  // Future<ApiResponse<void>> verifyAccount({
  //   required String email,
  //   required String verificationCode,
  // }) async {
  //   return postRequest<void>(
  //     endpoint: Endpoints.verifyAccount(),
  //     data: {
  //       "email": email,
  //       "verification_code": verificationCode,
  //     },
  //     fromJson: (_) {},
  //     errorMessage: 'Verification failed. Please check the code.',
  //   );
  // }
}
