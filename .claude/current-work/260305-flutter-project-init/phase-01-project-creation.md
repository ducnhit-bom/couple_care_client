# Phase 1: Project Creation & Dependencies

## Context
- Research report: [research-report.md](./research-report.md)
- Priority: P1 | Status: Pending

## Overview

Create Flutter project and configure all dependencies in pubspec.yaml.

## Implementation Steps

### 1. Create Flutter Project

```bash
cd /Users/baonguyen/Desktop/training/devops/cc
flutter create --org com.example --project-name cc_app --platforms android,ios .
```

**Note:** Running `flutter create .` in the existing `cc` directory will scaffold the project in-place. The `--org` flag sets the bundle identifier prefix. Adjust `com.example` to actual org domain.

### 2. Replace pubspec.yaml

**File:** `/Users/baonguyen/Desktop/training/devops/cc/pubspec.yaml` (modify)

```yaml
name: cc_app
description: "CC Flutter Application"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.7.0

dependencies:
  flutter:
    sdk: flutter

  # State Management & DI
  flutter_riverpod: ^3.2.1
  riverpod_annotation: ^2.6.1

  # HTTP Client
  dio: ^5.9.2

  # Firebase
  firebase_core: ^4.5.0
  firebase_auth: ^6.2.0
  cloud_firestore: ^6.1.3
  firebase_analytics: ^11.4.0

  # Navigation
  go_router: ^17.1.0

  # Serialization (runtime)
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0

  # Utilities
  flutter_secure_storage: ^9.2.4
  logger: ^2.5.0
  equatable: ^2.0.7
  # Result type handled by custom sealed class in core/utils/result.dart

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Linting
  flutter_lints: ^6.0.0

  # Code Generation
  build_runner: ^2.4.14
  freezed: ^3.2.5
  json_serializable: ^6.9.4
  riverpod_generator: ^2.6.4
  custom_lint: ^0.7.5
  riverpod_lint: ^2.6.4

  # Testing
  mocktail: ^1.0.4

flutter:
  uses-material-design: true
```

### 3. Install Dependencies

```bash
cd /Users/baonguyen/Desktop/training/devops/cc
flutter pub get
```

## Related Code Files
| Action | File |
|--------|------|
| modify | `/Users/baonguyen/Desktop/training/devops/cc/pubspec.yaml` |

## Success Criteria
- `flutter pub get` completes without errors
- All packages resolve correctly
- Project compiles with `flutter build apk --debug` (basic check)

## Risk Assessment
- Version conflicts between firebase packages. Mitigation: use versions confirmed compatible in research report.
- SDK constraint mismatch. Mitigation: verify Flutter SDK version first with `flutter --version`.
