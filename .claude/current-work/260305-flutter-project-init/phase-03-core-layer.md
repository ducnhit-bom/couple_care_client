# Phase 3: Core Layer - Environment, Errors, Base Classes

## Context
- Research report: [research-report.md](./research-report.md)
- Priority: P1 | Status: Pending

## Overview

Set up core infrastructure: environment config, error/failure types, base repository pattern, and logging.

## Implementation Steps

### 1. Environment Configuration

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/config/environment.dart` (create)

```dart
enum Flavor { dev, staging, prod }

class Environment {
  final String apiBaseUrl;
  final Flavor flavor;

  const Environment({
    required this.apiBaseUrl,
    required this.flavor,
  });

  factory Environment.fromDartDefine() {
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.dev.example.com',
    );
    const flavorStr = String.fromEnvironment(
      'FLAVOR',
      defaultValue: 'dev',
    );

    return Environment(
      apiBaseUrl: apiBaseUrl,
      flavor: Flavor.values.firstWhere(
        (f) => f.name == flavorStr,
        orElse: () => Flavor.dev,
      ),
    );
  }

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}
```

### 2. API Constants

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/constants/api_constants.dart` (create)

```dart
class ApiConstants {
  ApiConstants._();

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String register = '/auth/register';
}
```

### 3. Failures (Domain Layer)

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/errors/failures.dart` (create)

```dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred'});
}
```

### 4. Exceptions (Data Layer)

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/errors/exceptions.dart` (create)

```dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ServerException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache error'});
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException({this.message = 'Unauthorized'});
}
```

### 5. Error Handler (Exception -> Failure mapping)

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/errors/error_handler.dart` (create)

```dart
import 'package:dio/dio.dart';
import 'package:cc_app/core/errors/exceptions.dart';
import 'package:cc_app/core/errors/failures.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handleException(Object error) {
    if (error is ServerException) {
      return ServerFailure(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    if (error is NetworkException) {
      return NetworkFailure(message: error.message);
    }
    if (error is CacheException) {
      return CacheFailure(message: error.message);
    }
    if (error is UnauthorizedException) {
      return AuthFailure(message: error.message, statusCode: 401);
    }
    if (error is DioException) {
      return _handleDioError(error);
    }
    return UnknownFailure(message: error.toString());
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        final message = data is Map
            ? (data['message'] as String?) ?? 'Server error'
            : 'Server error';
        return ServerFailure(message: message, statusCode: statusCode);
      default:
        return UnknownFailure(message: error.message ?? 'Unknown error');
    }
  }
}
```

### 6. Logger Utility

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/utils/logger.dart` (create)

```dart
import 'package:logger/logger.dart' as lib;

final logger = lib.Logger(
  printer: lib.PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: false,
    dateTimeFormat: lib.DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
```

### 7. App Theme (Basic)

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/shared/theme/app_theme.dart` (create)

```dart
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      );
}
```

## Related Code Files
| Action | File |
|--------|------|
| create | `lib/core/config/environment.dart` |
| create | `lib/core/constants/api_constants.dart` |
| create | `lib/core/errors/failures.dart` |
| create | `lib/core/errors/exceptions.dart` |
| create | `lib/core/errors/error_handler.dart` |
| create | `lib/core/utils/logger.dart` |
| create | `lib/shared/theme/app_theme.dart` |

All paths relative to `/Users/baonguyen/Desktop/training/devops/cc/`.

## Success Criteria
- All files compile without errors
- `Environment.fromDartDefine()` correctly reads `--dart-define` values
- Error types cover: server, network, cache, auth, unknown
- `flutter analyze` passes

## Risk Assessment
- `dartz` Either type vs sealed class Result type: using `dartz` for `Either<Failure, T>` pattern. Alternative: write custom `Result` sealed class to avoid dependency. Recommend `dartz` for now (well-tested, widely used).
