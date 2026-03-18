# Phase 9: Smoke Test & Verification

## Context
- Priority: P2 | Status: Pending

## Overview

Verify the entire project compiles, analyzes clean, and runs. Create checklist for implementer.

## Implementation Steps

### 1. Run Static Analysis

```bash
cd /Users/baonguyen/Desktop/training/devops/cc
flutter analyze
```

Expected: 0 issues (warnings about unused imports acceptable at this stage).

### 2. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: Generates all `.g.dart` and `.freezed.dart` files without errors.

### 3. Compile Check

```bash
# Android
flutter build apk --debug

# iOS (macOS only)
flutter build ios --debug --no-codesign
```

### 4. Run App

```bash
flutter run --dart-define=API_BASE_URL=https://api.dev.example.com --dart-define=FLAVOR=dev
```

Expected: App launches, shows Home or Login page depending on Firebase Auth state.

### 5. Run Tests

```bash
flutter test
```

Expected: Default widget test may need updating. Ensure it passes or update to match new App widget.

### 6. Update Default Test

**File:** `/Users/baonguyen/Desktop/training/devops/cc/test/widget_test.dart` (modify)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App boots without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: Text('Test')),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });
}
```

## Verification Checklist

- [ ] `flutter pub get` succeeds
- [ ] `flutter analyze` returns 0 errors
- [ ] `dart run build_runner build` completes
- [ ] `flutter build apk --debug` compiles
- [ ] `flutter run` launches app
- [ ] `flutter test` passes
- [ ] Directory structure matches Phase 2 spec
- [ ] Firebase initializes (check console logs)
- [ ] GoRouter redirects to login when unauthenticated
- [ ] Dio client creates with correct base URL

## Success Criteria
- All checklist items pass
- Project is ready for feature development
