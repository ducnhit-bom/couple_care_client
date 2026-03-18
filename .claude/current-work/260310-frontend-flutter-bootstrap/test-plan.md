# Flutter Bootstrap Test Plan

## Scope
Validate the Flutter bootstrap path in `frontend` for analyzer cleanliness, generated code consistency, basic UI startup, buildability, and safe startup when Firebase remains on placeholder config.

## Test Matrix

| Area | Command / Method | Expected Result |
|---|---|---|
| Static analysis | `flutter analyze` | No errors |
| Widget test | `flutter test test/widget_test.dart` | App boots with `ProviderScope`, renders home screen, shows `Couple` and hero copy |
| Codegen verification | `dart run build_runner build --delete-conflicting-outputs` | Build succeeds and generated files stay in sync |
| Web build | `flutter build web --dart-define=ENABLE_FIREBASE=false` | Web bundle builds successfully |
| APK build | `flutter build apk --debug --dart-define=ENABLE_FIREBASE=false` | Debug APK builds successfully |
| Firebase startup safety | App startup with `ENABLE_FIREBASE=false` | Startup reaches `runApp()` without Firebase dependency |

## Exit Criteria
- All commands pass
- No bootstrap-related analyzer issues remain
- App launches to the home screen in the safe default path
