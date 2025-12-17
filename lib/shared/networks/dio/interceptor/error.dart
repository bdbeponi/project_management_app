/* ------------------------------------------------------------------ */
/* ERROR INTERCEPTOR                                                  */
/* ------------------------------------------------------------------ */

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioErrors extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Example: handle token expiration
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        print("⚠️ Unauthorized (401) - consider refreshing token or logout");
      }
      // TODO: trigger logout or refresh token flow here
      // For example:
      // await AuthService.refreshToken();
      // retry request if needed
    }

    // Example: handle server errors
    if (err.response?.statusCode == 500) {
      if (kDebugMode) {
        print("🚨 Server error (500): ${err.response?.data}");
      }
    }

    // Let Dio continue with the error
    return super.onError(err, handler);
  }
}

/* ------------------------------------------------------------------ */
/* ERROR INTERCEPTOR  Better version (Not Tested)                                                */
/* ------------------------------------------------------------------ */

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'dio_singleton.dart'; // adjust import to your project

// class AppErrorInterceptor extends Interceptor {
//   bool _isRefreshing = false;
//   final List<QueuedRequest> _queuedRequests = [];

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     // Handle only 401 Unauthorized
//     if (err.response?.statusCode == 401) {
//       final dio = DioSingleton.instance.dio;

//       // Queue this request until refresh finishes
//       final completer = Completer<Response>();
//       _queuedRequests.add(
//         QueuedRequest(options: err.requestOptions, completer: completer),
//       );

//       if (!_isRefreshing) {
//         _isRefreshing = true;

//         try {
//           final newToken = await _refreshToken();

//           if (newToken != null) {
//             // ✅ Update Dio headers with new token
//             DioSingleton.instance.updateAuth(newToken);

//             // Retry all queued requests with new token
//             for (final r in _queuedRequests) {
//               final opts = r.options;
//               opts.headers[NetworkConstants.AUTHORIZATION] = "Bearer $newToken";
//               try {
//                 final response = await dio.fetch(opts);
//                 r.completer.complete(response);
//               } catch (e) {
//                 r.completer.completeError(e);
//               }
//             }
//           } else {
//             // ❌ Refresh failed → logout user
//             _handleLogout();
//             for (final r in _queuedRequests) {
//               r.completer.completeError(err);
//             }
//           }
//         } catch (e) {
//           _handleLogout();
//         } finally {
//           _queuedRequests.clear();
//           _isRefreshing = false;
//         }
//       }

//       // Return a future that resolves after refresh/retry
//       return handler.resolve(await completer.future);
//     }

//     // For 500s or other errors
//     if (err.response?.statusCode == 500) {
//       if (kDebugMode) {
//         print("🚨 Server error (500): ${err.response?.data}");
//       }
//     }

//     return super.onError(err, handler);
//   }

//   /* ------------------------------------------------------------------ */
//   /* HELPERS                                                            */
//   /* ------------------------------------------------------------------ */

//   /// Call your refresh token API here
//   Future<String?> _refreshToken() async {
//     try {
//       if (kDebugMode) print("🔄 Refreshing token...");
//       final dio = DioSingleton.instance.dio;

//       final response = await dio.post(
//         "/auth/refresh", // your refresh endpoint
//         data: {
//           "refresh_token": "stored_refresh_token", // get from storage
//         },
//         options: Options(
//           headers: {NetworkConstants.AUTHORIZATION: null}, // no old token
//         ),
//       );

//       final newToken = response.data["access_token"] as String?;
//       if (newToken != null) {
//         if (kDebugMode) print("✅ Token refreshed");
//         return newToken;
//       }
//     } catch (e) {
//       if (kDebugMode) print("❌ Token refresh failed: $e");
//     }
//     return null;
//   }

//   /// Handle logout when refresh fails
//   void _handleLogout() {
//     if (kDebugMode) print("🚪 Logging out user...");
//     // TODO: Clear local storage, navigate to login, etc.
//   }
// }

// /* ------------------------------------------------------------------ */
// /* DATA CLASS FOR QUEUED REQUESTS                                     */
// /* ------------------------------------------------------------------ */

// class QueuedRequest {
//   final RequestOptions options;
//   final Completer<Response> completer;
//   QueuedRequest({required this.options, required this.completer});
// }
