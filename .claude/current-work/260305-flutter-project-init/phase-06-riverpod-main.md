# Phase 6: Riverpod & Main Entry Point

## Context
- Research report: [research-report.md](./research-report.md)
- Priority: P1 | Status: Pending

## Overview

Set up core Riverpod providers, ProviderScope in main.dart, and the root App widget.

## Implementation Steps

### 1. Core Providers

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/providers/core_providers.dart` (create)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc_app/core/config/environment.dart';
import 'package:cc_app/core/network/dio_client.dart';

/// Environment config (reads --dart-define values)
final environmentProvider = Provider<Environment>(
  (ref) => Environment.fromDartDefine(),
);

/// Auth tokens (in-memory state, hydrate from secure storage on startup)
final authTokenProvider = StateProvider<String?>((ref) => null);
final refreshTokenProvider = StateProvider<String?>((ref) => null);

/// Dio HTTP client
final dioProvider = Provider<Dio>((ref) {
  final environment = ref.watch(environmentProvider);
  return createDioClient(ref: ref, environment: environment);
});
```

### 2. Main Entry Point

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/main.dart` (modify)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc_app/core/config/firebase_config.dart';
import 'package:cc_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
```

### 3. App Widget

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/app.dart` (create)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc_app/core/providers/firebase_providers.dart';
import 'package:cc_app/router/app_router.dart';
import 'package:cc_app/shared/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CC App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

## Related Code Files
| Action | File |
|--------|------|
| create | `lib/core/providers/core_providers.dart` |
| modify | `lib/main.dart` |
| create | `lib/app.dart` |

All paths relative to `/Users/baonguyen/Desktop/training/devops/cc/`.

## Success Criteria
- App boots with ProviderScope wrapping root widget
- Firebase initializes before runApp
- MaterialApp.router uses go_router config
- Theme applies correctly
- No provider initialization errors

## Security Considerations
- Auth tokens stored in StateProvider (volatile memory). For persistence across app restarts, add hydration logic from `flutter_secure_storage` in a future phase.
