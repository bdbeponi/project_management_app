// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:project_management/shared/networks/dio/interceptor/error.dart';
// import 'package:project_management/shared/networks/dio/interceptor/log.dart';
// import 'package:project_management/shared/networks/endpoints.dart';

// final class DioSingleton {
//   static final DioSingleton _singleton = DioSingleton._internal();
//   static DioSingleton get instance => _singleton;

//   late final Dio dio;

//   DioSingleton._internal() {
//     final options = BaseOptions(
//       baseUrl: url,
//       connectTimeout: const Duration(milliseconds: 100000),
//       receiveTimeout: const Duration(milliseconds: 100000),
//       headers: {
//         NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
//         NetworkConstants.ACCEPT_LANGUAGE: "en",
//         NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
//       },
//       responseType: ResponseType.json,
//     );

//     dio = Dio(options)..interceptors.addAll([DioLogger(), DioErrors()]);
//   }

//   /// Update Authorization header only
//   void updateAuth(String auth) {
//     if (kDebugMode) print("Dio updateAuth");
//     dio.options.headers[NetworkConstants.AUTHORIZATION] = "Bearer $auth";
//   }

//   /// Update language header only
//   void updateLanguage(String countryCode) {
//     if (kDebugMode) print("Dio updateLanguage: $countryCode");
//     dio.options.headers[NetworkConstants.ACCEPT_LANGUAGE] = countryCode;
//   }
// }

// /* ------------------------------------------------------------------ */
// /* GENERIC HELPERS                                                    */
// /* ------------------------------------------------------------------ */

// Future<Response<T>> getHttp<T>(
//   String path, {
//   Map<String, dynamic>? query,
//   CancelToken? cancelToken,
// }) => DioSingleton.instance.dio.get<T>(
//   path,
//   queryParameters: query,
//   cancelToken: cancelToken ?? CancelToken(),
// );

// Future<Response<T>> postHttp<T>(
//   String path, {
//   dynamic data,
//   CancelToken? cancelToken,
// }) => DioSingleton.instance.dio.post<T>(
//   path,
//   data: data,
//   cancelToken: cancelToken ?? CancelToken(),
// );

// Future<Response<T>> putHttp<T>(
//   String path, {
//   dynamic data,
//   CancelToken? cancelToken,
// }) => DioSingleton.instance.dio.put<T>(
//   path,
//   data: data,
//   cancelToken: cancelToken ?? CancelToken(),
// );

// Future<Response<T>> deleteHttp<T>(
//   String path, {
//   dynamic data,
//   CancelToken? cancelToken,
// }) => DioSingleton.instance.dio.delete<T>(
//   path,
//   data: data,
//   cancelToken: cancelToken ?? CancelToken(),
// );

import 'package:dio/dio.dart';
import 'package:project_management/shared/networks/dio/interceptor/error.dart';
import 'package:project_management/shared/networks/dio/interceptor/log.dart';
import 'package:project_management/shared/networks/endpoints.dart';
import 'package:project_management/shared/networks/exception_handler/data_source.dart';

final class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  static DioSingleton get instance => _singleton;

  late final Dio dio;
  CancelToken _globalCancelToken = CancelToken();

  DioSingleton._internal() {
    final options = BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.ACCEPT_LANGUAGE: "en",
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
      },
      responseType: ResponseType.json,
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    );

    dio = Dio(options)
      ..interceptors.addAll([
        // if (kDebugMode) // Only add logger in debug mode
        //   CustomDioLogger(
        //     level: LogLevel.debug,
        //     showTimestamp: true,
        //     logPrint: (message) {
        //       if (kDebugMode) print(message);
        //     },
        //   ),
        DioLogger(),
        DioErrors(),
      ]);
  }

  void updateAuth(String auth) {
    dio.options.headers[NetworkConstants.AUTHORIZATION] = "Bearer $auth";
  }

  void clearAuth() {
    dio.options.headers.remove(NetworkConstants.AUTHORIZATION);
  }

  void updateLanguage(String countryCode) {
    dio.options.headers[NetworkConstants.ACCEPT_LANGUAGE] = countryCode;
  }

  void cancelAllRequests() {
    _globalCancelToken.cancel('All requests cancelled');
    _globalCancelToken = CancelToken();
  }

  CancelToken get cancelToken => _globalCancelToken;
}

/* ------------------------------------------------------------------ */
/* GENERIC RESPONSE HANDLING                                          */
/* ------------------------------------------------------------------ */

// Generic API response wrapper
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      data: null,
    );
  }
}

// Helper for making API calls with proper error handling
Future<ApiResponse<T>> safeApiCall<T>({
  required Future<Response> Function() apiCall,
  required T Function(Map<String, dynamic>) fromJson,
  String? customErrorMessage,
}) async {
  try {
    final response = await apiCall();

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      try {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : {'data': response.data};

        final result = fromJson(data);
        return ApiResponse.success(result, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          'Failed to parse response: $e',
          statusCode: response.statusCode,
        );
      }
    } else {
      return ApiResponse.error(
        customErrorMessage ??
            'Request failed with status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  } on DioException catch (e) {
    final failure = ErrorHandler.handle(e);
    return ApiResponse.error(
      customErrorMessage ?? failure.responseMessage,
      statusCode: failure.responseCode,
    );
  } catch (e) {
    return ApiResponse.error(
      customErrorMessage ?? 'An unexpected error occurred: $e',
    );
  }
}

// HTTP method wrappers with better typing
Future<Response<T>> getHttp<T>(
  String path, {
  Map<String, dynamic>? query,
  Options? options,
  CancelToken? cancelToken,
  bool useGlobalCancelToken = true,
}) {
  return DioSingleton.instance.dio.get<T>(
    path,
    queryParameters: query,
    options: options,
    cancelToken: useGlobalCancelToken
        ? DioSingleton.instance.cancelToken
        : cancelToken,
  );
}

Future<Response<T>> postHttp<T>(
  String path, {
  dynamic data,
  Options? options,
  CancelToken? cancelToken,
  bool useGlobalCancelToken = true,
}) {
  return DioSingleton.instance.dio.post<T>(
    path,
    data: data,
    options: options ?? Options(headers: {'Content-Type': 'application/json'}),
    cancelToken: useGlobalCancelToken
        ? DioSingleton.instance.cancelToken
        : cancelToken,
  );
}

Future<Response<T>> putHttp<T>(
  String path, {
  dynamic data,
  Options? options,
  CancelToken? cancelToken,
  bool useGlobalCancelToken = true,
}) {
  return DioSingleton.instance.dio.put<T>(
    path,
    data: data,
    options: options ?? Options(headers: {'Content-Type': 'application/json'}),
    cancelToken: useGlobalCancelToken
        ? DioSingleton.instance.cancelToken
        : cancelToken,
  );
}

Future<Response<T>> patchHttp<T>(
  String path, {
  dynamic data,
  Options? options,
  CancelToken? cancelToken,
  bool useGlobalCancelToken = true,
}) {
  return DioSingleton.instance.dio.patch<T>(
    path,
    data: data,
    options: options ?? Options(headers: {'Content-Type': 'application/json'}),
    cancelToken: useGlobalCancelToken
        ? DioSingleton.instance.cancelToken
        : cancelToken,
  );
}

Future<Response<T>> deleteHttp<T>(
  String path, {
  dynamic data,
  Options? options,
  CancelToken? cancelToken,
  bool useGlobalCancelToken = true,
}) {
  return DioSingleton.instance.dio.delete<T>(
    path,
    data: data,
    options: options,
    cancelToken: useGlobalCancelToken
        ? DioSingleton.instance.cancelToken
        : cancelToken,
  );
}
