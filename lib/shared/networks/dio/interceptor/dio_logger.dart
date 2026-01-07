// shared/networks/dio/interceptor/custom_dio_logger.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Log levels for different types of logs
enum LogLevel {
  none, // No logs
  error, // Only errors
  info, // Errors + basic info
  debug, // Errors + info + request/response details
  verbose, // Everything including full bodies
}

/// Custom Dio logger interceptor
class CustomDioLogger extends Interceptor {
  final LogLevel level;
  final Set<String> _redactedHeaders = {'authorization', 'cookie', 'token'};
  final int _maxBodyLength = 1000;
  final void Function(String) _logPrint;
  final bool showTimestamp;

  /// Request timing tracking
  static const String _startTimeKey = '_start_time';

  CustomDioLogger({
    this.level = LogLevel.info,
    void Function(String)? logPrint,
    this.showTimestamp = true,
  }) : _logPrint = logPrint ?? _defaultLogPrint;

  static void _defaultLogPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  /* ------------------------------------------------------------------ */
  /* REQUEST LOGGING                                                    */
  /* ------------------------------------------------------------------ */
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (level.index < LogLevel.debug.index) {
      handler.next(options);
      return;
    }

    // Store start time for duration calculation
    options.extra[_startTimeKey] = DateTime.now();

    final buffer = StringBuffer();

    if (showTimestamp) {
      buffer.write('[${_formatTime(DateTime.now())}] ');
    }

    buffer.write('🌐 REQUEST: ${options.method.toUpperCase()} ${options.uri}');

    if (level.index >= LogLevel.debug.index) {
      if (options.queryParameters.isNotEmpty) {
        buffer.write('\n  📋 Query: ${_formatMap(options.queryParameters)}');
      }

      final headers = _redactHeaders(options.headers);
      if (headers.isNotEmpty) {
        buffer.write('\n  📄 Headers: ${_formatMap(headers)}');
      }

      if (level.index >= LogLevel.verbose.index && options.data != null) {
        buffer.write('\n  📦 Body: ${_formatBody(options.data)}');
      }
    }

    _logPrint(buffer.toString());
    handler.next(options);
  }

  /* ------------------------------------------------------------------ */
  /* RESPONSE LOGGING                                                   */
  /* ------------------------------------------------------------------ */
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (level.index < LogLevel.info.index) {
      handler.next(response);
      return;
    }

    final startTime = response.requestOptions.extra[_startTimeKey] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : null;

    final buffer = StringBuffer();

    if (showTimestamp) {
      buffer.write('[${_formatTime(DateTime.now())}] ');
    }

    final statusCode = response.statusCode;
    final icon = _getStatusIcon(statusCode);

    buffer.write(
      '$icon RESPONSE: ${response.requestOptions.method.toUpperCase()} '
      '${response.requestOptions.uri}',
    );

    if (duration != null) {
      buffer.write(' • ${duration}ms');
    }

    buffer.write('\n  ⚡ Status: $statusCode ${response.statusMessage ?? ''}');

    if (level.index >= LogLevel.debug.index) {
      final headers = _redactHeaders(response.headers.map);
      if (headers.isNotEmpty) {
        buffer.write('\n  📄 Headers: ${_formatMap(headers)}');
      }

      if (level.index >= LogLevel.verbose.index && response.data != null) {
        buffer.write('\n  📦 Body: ${_formatBody(response.data)}');
      } else if (level.index >= LogLevel.debug.index && response.data != null) {
        final bodyPreview = _truncateString(response.data.toString());
        buffer.write('\n  📦 Body (preview): $bodyPreview');
      }
    }

    _logPrint(buffer.toString());
    handler.next(response);
  }

  /* ------------------------------------------------------------------ */
  /* ERROR LOGGING                                                      */
  /* ------------------------------------------------------------------ */
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (level.index < LogLevel.error.index) {
      handler.next(err);
      return;
    }

    final buffer = StringBuffer();

    if (showTimestamp) {
      buffer.write('[${_formatTime(DateTime.now())}] ');
    }

    buffer.write('❌ ERROR: ${err.type.name.toUpperCase()}');

    if (err.response != null) {
      buffer.write(' • Status: ${err.response!.statusCode}');
    }

    buffer.write(
      '\n  🚫 ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}',
    );
    buffer.write('\n  💬 Message: ${err.message}');

    if (err.response != null && level.index >= LogLevel.debug.index) {
      final headers = _redactHeaders(err.response!.headers.map);
      if (headers.isNotEmpty) {
        buffer.write('\n  📄 Headers: ${_formatMap(headers)}');
      }

      if (level.index >= LogLevel.verbose.index && err.response!.data != null) {
        buffer.write('\n  📦 Error Body: ${_formatBody(err.response!.data)}');
      }
    }

    if (err.error != null && err.error is! DioException) {
      buffer.write('\n  🐛 Error Details: ${err.error}');
    }

    if (level.index >= LogLevel.verbose.index) {
      buffer.write('\n  🔍 Stack Trace: ${err.stackTrace}');
    }

    _logPrint(buffer.toString());
    handler.next(err);
  }

  /* ------------------------------------------------------------------ */
  /* HELPER METHODS                                                     */
  /* ------------------------------------------------------------------ */

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}.'
        '${time.millisecond.toString().padLeft(3, '0')}';
  }

  String _getStatusIcon(int? statusCode) {
    if (statusCode == null) return '❓';
    if (statusCode >= 200 && statusCode < 300) return '✅';
    if (statusCode >= 300 && statusCode < 400) return '🔄';
    if (statusCode >= 400 && statusCode < 500) return '⚠️';
    if (statusCode >= 500) return '🔥';
    return '❓';
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    final result = <String, dynamic>{};

    headers.forEach((key, value) {
      if (_redactedHeaders.contains(key.toLowerCase())) {
        result[key] = '•••••';
      } else {
        result[key] = value;
      }
    });

    return result;
  }

  String _formatMap(Map<String, dynamic> map) {
    if (map.isEmpty) return '{}';

    final buffer = StringBuffer();
    buffer.write('{\n');

    map.forEach((key, value) {
      buffer.write('    $key: ${_formatValue(value)},\n');
    });

    buffer.write('  }');
    return buffer.toString();
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is List) return 'List[${value.length}]';
    if (value is Map) return 'Map[${value.length}]';
    return value.toString();
  }

  String _formatBody(dynamic data) {
    try {
      String formatted;

      if (data is Map || data is List) {
        formatted = const JsonEncoder.withIndent('  ').convert(data);
      } else if (data is FormData) {
        final fields = {for (final f in data.fields) f.key: '•••••'};
        final files = data.files.map((f) => f.key).toList();
        formatted = 'FormData(fields: $fields, files: $files)';
      } else if (data is String) {
        formatted = data;
      } else {
        formatted = data.toString();
      }

      return _truncateString(formatted);
    } catch (e) {
      return 'Error formatting body: $e';
    }
  }

  String _truncateString(String input) {
    if (input.length <= _maxBodyLength) return input;
    return '${input.substring(0, _maxBodyLength)}... '
        '[${input.length - _maxBodyLength} more characters]';
  }
}
