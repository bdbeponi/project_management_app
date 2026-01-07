// lib/shared/networks/dio/base_api.dart
import 'package:project_management/shared/networks/dio/dio.dart';

abstract class BaseApi {
  Future<ApiResponse<T>> getRequest<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
    String? errorMessage,
  }) async {
    return safeApiCall<T>(
      apiCall: () => getHttp(endpoint, query: queryParameters),
      fromJson: fromJson,
      customErrorMessage: errorMessage,
    );
  }

  Future<ApiResponse<T>> postRequest<T>({
    required String endpoint,
    required dynamic data,
    required T Function(Map<String, dynamic>) fromJson,
    String? errorMessage,
  }) async {
    return safeApiCall<T>(
      apiCall: () => postHttp(endpoint, data: data),
      fromJson: fromJson,
      customErrorMessage: errorMessage,
    );
  }

  Future<ApiResponse<T>> putRequest<T>({
    required String endpoint,
    required dynamic data,
    required T Function(Map<String, dynamic>) fromJson,
    String? errorMessage,
  }) async {
    return safeApiCall<T>(
      apiCall: () => putHttp(endpoint, data: data),
      fromJson: fromJson,
      customErrorMessage: errorMessage,
    );
  }

  Future<ApiResponse<T>> deleteRequest<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    String? errorMessage,
  }) async {
    return safeApiCall<T>(
      apiCall: () => deleteHttp(endpoint, data: data),
      fromJson: fromJson,
      customErrorMessage: errorMessage,
    );
  }
}
