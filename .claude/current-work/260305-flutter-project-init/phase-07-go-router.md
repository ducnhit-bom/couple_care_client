# Phase 7: GoRouter Navigation

## Context
- Research report: [research-report.md](./research-report.md)
- Priority: P1 | Status: Pending

## Overview

Configure go_router with route definitions, auth redirect guard, and analytics observer. Expose as Riverpod provider.

## Implementation Steps

### 1. Router Configuration

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/router/app_router.dart` (create)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cc_app/core/providers/firebase_providers.dart';
import 'package:cc_app/router/route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    observers: [ref.watch(analyticsObserverProvider)],
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      // Not logged in -> redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return '/auth/login';
      }

      // Logged in but on auth page -> redirect to home
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.home,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home - Replace with actual page')),
        ),
      ),

      // Auth routes
      GoRoute(
        path: '/auth/login',
        name: RouteNames.login,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login - Replace with actual page')),
        ),
      ),
      GoRoute(
        path: '/auth/register',
        name: RouteNames.register,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Register - Replace with actual page')),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
```

### 2. Route Names Constants

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/router/route_names.dart` (create)

```dart
class RouteNames {
  RouteNames._();

  static const String home = 'home';
  static const String login = 'login';
  static const String register = 'register';
}
```

## Related Code Files
| Action | File |
|--------|------|
| create | `lib/router/app_router.dart` |
| create | `lib/router/route_names.dart` |

All paths relative to `/Users/baonguyen/Desktop/training/devops/cc/`.

## Success Criteria
- Router redirects unauthenticated users to login
- Router redirects authenticated users away from auth pages
- Named routes work (`context.goNamed(RouteNames.home)`)
- Analytics observer tracks page views
- Error page shows for unknown routes

## Notes
- Placeholder Scaffolds used for pages. Replace with actual feature pages as they are built.
- Auth redirect uses `authStateProvider` (Firebase Auth stream) so navigation reacts to auth changes automatically.
