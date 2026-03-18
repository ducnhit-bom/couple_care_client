# Phase 5: Firebase Initialization

## Context
- Research report: [research-report.md](./research-report.md)
- Priority: P1 | Status: Pending

## Overview

Set up Firebase (Core, Auth, Firestore, Analytics) using FlutterFire CLI and configure Riverpod providers for Firebase services.

## Prerequisites
- No Firebase project required yet — placeholder structure is created now.
- To activate Firebase later: install FlutterFire CLI (`dart pub global activate flutterfire_cli`) and run `flutterfire configure --project=YOUR_PROJECT_ID`

## Implementation Steps

### 1. Create Placeholder firebase_options.dart

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/firebase_options.dart` (create)

```dart
// PLACEHOLDER: Replace by running `flutterfire configure --project=YOUR_PROJECT_ID`
// Firebase features will NOT work until this file is replaced with real config.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase not configured for this platform. Run `flutterfire configure`.',
        );
    }
  }

  // STUB values — replace with real Firebase Console values
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'PLACEHOLDER_API_KEY',
    appId: '1:000000000000:android:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'YOUR_FIREBASE_PROJECT_ID',
    storageBucket: 'YOUR_FIREBASE_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'PLACEHOLDER_API_KEY',
    appId: '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'YOUR_FIREBASE_PROJECT_ID',
    storageBucket: 'YOUR_FIREBASE_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.ccApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'PLACEHOLDER_API_KEY',
    appId: '1:000000000000:web:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'YOUR_FIREBASE_PROJECT_ID',
    storageBucket: 'YOUR_FIREBASE_PROJECT_ID.appspot.com',
  );
}
```

### 2. Firebase Config Wrapper (Optional, for multi-environment)

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/config/firebase_config.dart` (create)

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cc_app/firebase_options.dart';

class FirebaseConfig {
  FirebaseConfig._();

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
```

### 3. Firebase Riverpod Providers

**File:** `/Users/baonguyen/Desktop/training/devops/cc/lib/core/providers/firebase_providers.dart` (create)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firebase Auth instance
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

/// Auth state stream
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

/// Firestore instance
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Analytics instance
final analyticsProvider = Provider<FirebaseAnalytics>(
  (ref) => FirebaseAnalytics.instance,
);

/// Analytics observer for GoRouter/Navigator
final analyticsObserverProvider = Provider<FirebaseAnalyticsObserver>(
  (ref) => FirebaseAnalyticsObserver(
    analytics: ref.watch(analyticsProvider),
  ),
);
```

### 4. Android Configuration

Verify these are set after `flutterfire configure`:

**File:** `/Users/baonguyen/Desktop/training/devops/cc/android/app/build.gradle`

Should contain:
```groovy
plugins {
    id "com.google.gms.google-services"
}

// minSdkVersion should be >= 21
defaultConfig {
    minSdkVersion 23  // Required for firebase_auth
}
```

**File:** `/Users/baonguyen/Desktop/training/devops/cc/android/build.gradle`

Should contain:
```groovy
dependencies {
    classpath 'com.google.gms:google-services:4.4.2'
}
```

### 5. iOS Configuration

Verify in `/Users/baonguyen/Desktop/training/devops/cc/ios/Podfile`:

```ruby
platform :ios, '13.0'  # Minimum for Firebase
```

## Related Code Files
| Action | File |
|--------|------|
| create | `lib/core/config/firebase_config.dart` |
| create | `lib/core/providers/firebase_providers.dart` |
| create | `lib/firebase_options.dart` (placeholder) |
| manual-later | `android/app/google-services.json` (after flutterfire configure) |
| manual-later | `ios/Runner/GoogleService-Info.plist` (after flutterfire configure) |

All paths relative to `/Users/baonguyen/Desktop/training/devops/cc/`.

## Success Criteria
- `lib/firebase_options.dart` placeholder created and compiles
- Firebase providers compile without errors
- `FirebaseConfig.initialize()` runs without crash (uses placeholder values)
- Note: Real Firebase features require replacing placeholder with `flutterfire configure` output

## Risk Assessment
- FlutterFire CLI version mismatch. Mitigation: install latest version before running.
- Android minSdkVersion too low. Mitigation: set to 23 explicitly.
- iOS deployment target too low. Mitigation: set to 13.0 in Podfile.
