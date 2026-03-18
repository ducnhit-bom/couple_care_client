# Phase 4: Dio Configuration & Interceptors

## Context
- Research report: [research-report.md](./research-report.md)
- Priority: P1 | Status: Pending

## Overview

Configure Dio HTTP client with base options, auth interceptor (token attach + refresh), logging interceptor, and error interceptor. Expose via Riverpod provider.

## Key Insights
- Use `QueuedInterceptorsWrapper` to prevent race conditions during token refresh
- "One future" pattern: only one refresh call at a time, all queued requests wait for same future
- Separate interceptors for auth, logging, error handling (SRP)

## Implementation Steps

### 1. Auth Interceptor

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/network/auth_interceptor.dart` (create)

```dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc_app/core/providers/core_providers.dart';
import 'package:cc_app/core/utils/logger.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final Ref _ref;
  final Dio _dio;
  Completer<String?>? _refreshCompleter;

  AuthInterceptor({required Ref ref, required Dio dio})
      : _ref = ref,
        _dio = dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(authTokenProvider);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      final newToken = await _refreshToken();
      if (newToken == null) {
        return handler.next(err);
      }

      // Retry original request with new token
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      logger.e('Token refresh failed: $e');
      // Clear auth state, force re-login
      _ref.read(authTokenProvider.notifier).state = null;
      return handler.next(err);
    }
  }

  /// One-future pattern: prevents multiple simultaneous refresh calls
  Future<String?> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();
    try {
      final refreshToken = _ref.read(refreshTokenProvider);
      if (refreshToken == null) {
        _refreshCompleter!.complete(null);
        return null;
      }

      // Use a separate Dio instance to avoid interceptor loop
      final refreshDio = Dio(BaseOptions(
        baseUrl: _dio.options.baseUrl,
      ));

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'] as String?;
      final newRefreshToken = response.data['refresh_token'] as String?;

      if (newAccessToken != null) {
        _ref.read(authTokenProvider.notifier).state = newAccessToken;
        if (newRefreshToken != null) {
          _ref.read(refreshTokenProvider.notifier).state = newRefreshToken;
        }
      }

      _refreshCompleter!.complete(newAccessToken);
      return newAccessToken;
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }
}
```

### 2. Logging Interceptor

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/network/logging_interceptor.dart` (create)

```dart
import 'package:dio/dio.dart';
import 'package:cc_app/core/utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d('>> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('<< ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('<< ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
    handler.next(err);
  }
}
```

### 3. Dio Client Configuration

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/network/dio_client.dart` (create)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc_app/core/config/environment.dart';
import 'package:cc_app/core/constants/api_constants.dart';
import 'package:cc_app/core/network/auth_interceptor.dart';
import 'package:cc_app/core/network/logging_interceptor.dart';

Dio createDioClient({
  required Ref ref,
  required Environment environment,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: environment.apiBaseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Order matters: auth first, then logging
  dio.interceptors.addAll([
    AuthInterceptor(ref: ref, dio: dio),
    if (!environment.isProd) LoggingInterceptor(),
  ]);

  return dio;
}
```

### 4. API Interceptor (Generic Error Interceptor)

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/network/api_interceptor.dart` (create)

```dart
import 'package:dio/dio.dart';
import 'package:cc_app/core/errors/exceptions.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        error: const NetworkException(),
        type: DioExceptionType.unknown,
      ));
      return;
    }

    final statusCode = err.response?.statusCode;
    if (statusCode != null) {
      final data = err.response?.data;
      final message = data is Map
          ? (data['message'] as String?) ?? 'Server error'
          : 'Server error';
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        error: ServerException(message: message, statusCode: statusCode),
        response: err.response,
        type: DioExceptionType.badResponse,
      ));
      return;
    }

    handler.next(err);
  }
}
```

## Related Code Files
| Action | File |
|--------|------|
| create | `lib/core/network/auth_interceptor.dart` |
| create | `lib/core/network/logging_interceptor.dart` |
| create | `lib/core/network/dio_client.dart` |
| create | `lib/core/network/api_interceptor.dart` |

All paths relative to `/Users/baonguyen/Desktop/training/devops/cc/`.

## Success Criteria
- Dio client creates with correct base URL from environment
- Auth interceptor attaches token to requests
- 401 triggers token refresh with one-future pattern (no race conditions)
- Logging interceptor only active in non-prod
- All files compile without errors

## Risk Assessment
- Circular dependency: AuthInterceptor uses Dio to refresh -> uses separate Dio instance. Safe.
- Token stored in StateProvider (in-memory). For persistence, integrate `flutter_secure_storage` in Phase 6 providers.
