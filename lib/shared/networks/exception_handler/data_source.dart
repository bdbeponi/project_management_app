// // ignore_for_file: constant_identifier_names
// import 'dart:developer';

// import 'package:dio/dio.dart';

// import 'error_response.dart';

// enum DataSource {
//   SUCCESS,
//   NO_CONTENT,
//   BAD_REQUEST,
//   FORBIDDEN,
//   UNAUTORISED,
//   NOT_FOUND,
//   INTERNAL_SERVER_ERROR,
//   CONNECT_TIMEOUT,
//   CANCEL,
//   RECIEVE_TIMEOUT,
//   SEND_TIMEOUT,
//   CACHE_ERROR,
//   NO_INTERNET_CONNECTION,
//   DEFAULT
// }

// extension DataSourceExtension on DataSource {
//   Failure getFailure() {
//     switch (this) {
//       case DataSource.SUCCESS:
//         return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
//       case DataSource.NO_CONTENT:
//         return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
//       case DataSource.BAD_REQUEST:
//         return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
//       case DataSource.FORBIDDEN:
//         return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
//       case DataSource.UNAUTORISED:
//         return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED);
//       case DataSource.NOT_FOUND:
//         return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
//       case DataSource.INTERNAL_SERVER_ERROR:
//         return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
//             ResponseMessage.INTERNAL_SERVER_ERROR);
//       case DataSource.CONNECT_TIMEOUT:
//         return Failure(
//             ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);
//       case DataSource.CANCEL:
//         return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
//       case DataSource.RECIEVE_TIMEOUT:
//         return Failure(
//             ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT);
//       case DataSource.SEND_TIMEOUT:
//         return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
//       case DataSource.CACHE_ERROR:
//         return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
//       case DataSource.NO_INTERNET_CONNECTION:
//         return Failure(ResponseCode.NO_INTERNET_CONNECTION,
//             ResponseMessage.NO_INTERNET_CONNECTION);
//       case DataSource.DEFAULT:
//         return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
//     }
//   }
// }

// final class Failure {
//   final int resonseCode;
//   final String responseMessage;

//   Failure(this.resonseCode, this.responseMessage);
//   // {
//   //   log("Getting called:$responseMessage");
//   //   // ScaffoldMessenger.of(NavigationService.context).showSnackBar(SnackBar(
//   //   //   content: Text(responseMessage),
//   //   // ));
//   // }
// }

// final class ErrorHandler implements Exception {
//   late Failure failure;

//   ErrorHandler.handle(dynamic error) {
//     if (error is DioException) {
//       // dio error so its an error from response of the API or from dio itself
//       failure = _handleError(error);
//     } else {
//       log(error.toString());
//       // default error
//       failure = DataSource.DEFAULT.getFailure();
//     }
//   }

//   Failure _handleError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//         return DataSource.CONNECT_TIMEOUT.getFailure();
//       case DioExceptionType.sendTimeout:
//         return DataSource.SEND_TIMEOUT.getFailure();
//       case DioExceptionType.receiveTimeout:
//         return DataSource.RECIEVE_TIMEOUT.getFailure();
//       case DioExceptionType.badResponse:
//         if (error.response != null &&
//             error.response?.statusCode != null &&
//             error.response?.statusMessage != null) {
//           return Failure(error.response?.statusCode ?? 0,
//               error.response?.statusMessage ?? "");
//         } else {
//           return DataSource.DEFAULT.getFailure();
//         }
//       case DioExceptionType.cancel:
//         return DataSource.CANCEL.getFailure();
//       default:
//         return DataSource.DEFAULT.getFailure();
//     }
//   }
// }

// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:dio/dio.dart';

import 'error_response.dart';

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
          ResponseCode.CONNECT_TIMEOUT,
          ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
          ResponseCode.RECIEVE_TIMEOUT,
          ResponseMessage.RECIEVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

final class Failure implements Exception {
  final int responseCode; // ✅ Fixed: 'responseCode' not 'resonseCode'
  final String responseMessage;

  Failure(this.responseCode, this.responseMessage);

  @override
  String toString() => 'Failure($responseCode): $responseMessage';

  // Optional: Add equality support
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          responseCode == other.responseCode &&
          responseMessage == other.responseMessage;

  @override
  int get hashCode => responseCode.hashCode ^ responseMessage.hashCode;
}

final class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is Failure) {
      return error; // Already a Failure, just return it
    } else {
      // For any other type of error
      return DataSource.DEFAULT.getFailure();
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECIEVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.unknown:
        // Check if it's a connectivity error
        if (error.error != null &&
            error.error.toString().contains('SocketException')) {
          return DataSource.NO_INTERNET_CONNECTION.getFailure();
        }
        return DataSource.DEFAULT.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  }

  static Failure _handleBadResponse(DioException error) {
    final response = error.response;
    if (response == null) {
      return DataSource.DEFAULT.getFailure();
    }

    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    // Try to get error message from response
    String errorMessage =
        _extractErrorMessage(responseData) ??
        response.statusMessage ??
        _getDefaultMessageForStatusCode(statusCode);

    return Failure(statusCode, errorMessage);
  }

  static String? _extractErrorMessage(dynamic responseData) {
    try {
      if (responseData == null) return null;

      // If it's already a string
      if (responseData is String) {
        // Try to parse as JSON
        try {
          final json = jsonDecode(responseData) as Map<String, dynamic>;
          return json['message'] ??
              json['error'] ??
              json['error_description'] ??
              responseData;
        } catch (e) {
          return responseData; // Return the string as-is
        }
      }

      // If it's a Map
      if (responseData is Map<String, dynamic>) {
        return responseData['message'] ??
            responseData['error'] ??
            responseData['error_description'] ??
            responseData['detail'] ??
            responseData['title'];
      }

      // If it's a List (some APIs return errors in array)
      if (responseData is List) {
        return responseData.isNotEmpty ? responseData[0].toString() : null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static String _getDefaultMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return ResponseMessage.BAD_REQUEST;
      case 401:
        return ResponseMessage.UNAUTORISED;
      case 403:
        return ResponseMessage.FORBIDDEN;
      case 404:
        return ResponseMessage.NOT_FOUND;
      case 408:
        return 'Request timeout';
      case 409:
        return 'Conflict';
      case 429:
        return 'Too many requests';
      case 500:
        return ResponseMessage.INTERNAL_SERVER_ERROR;
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      case 504:
        return 'Gateway timeout';
      default:
        return ResponseMessage.DEFAULT;
    }
  }
}
