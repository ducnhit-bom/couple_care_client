# Flutter Project Initialization Research Report
**Date:** 2026-03-05 | **Stack:** Clean Architecture + Riverpod + Dio + Firebase

---

## 1. Folder Structure: Feature-First Clean Architecture

**Recommended Pattern:**
```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── pages/
│   │       └── widgets/
│   └── [other features]
├── core/
│   ├── config/
│   │   ├── dio_config.dart
│   │   ├── firebase_config.dart
│   │   └── environment.dart
│   ├── providers/ (shared Riverpod)
│   ├── utils/
│   └── failures/
└── main.dart
```

**Rationale:** Feature-first simplifies scaling as projects grow; easier to locate all related code. Layer-first causes developers to "jump" across directories. Hybrid approach balances both.

---

## 2. Latest Stable Package Versions (March 2026)

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^3.2.1 | State management & dependency injection |
| riverpod_annotation | ^2.x | Code generation for Riverpod |
| dio | ^5.9.2 | HTTP client with interceptors |
| firebase_core | ^4.5.0 | Firebase initialization |
| firebase_auth | ^6.2.0 | Firebase authentication |
| cloud_firestore | ^6.1.3 | NoSQL database |
| firebase_analytics | ^11.x+ | Analytics tracking |
| freezed | ^3.2.5 | Immutable model generation |
| json_serializable | ^6.x+ | JSON serialization |
| go_router | ^17.1.0 | Navigation & routing |
| flutter_lints | ^6.0.0 | Code style & linting |

---

## 3. Architecture Decision: Feature-First vs Layer-First

**Feature-First (Recommended):**
- All code for "auth," "orders," etc. in single feature folder
- Each feature contains mini-layers (data/domain/presentation)
- Superior for scalability; reduces file jumping
- Modern standard in Flutter community

**Layer-First (Traditional):**
- Separate presentation/, domain/, data/ at root
- Feature folders within each layer
- High boilerplate; developers navigate multiple directories
- Less suitable for growing apps

**Verdict:** Use feature-first with Clean Architecture layers nested per feature.

---

## 4. Dio Configuration: Interceptors, Auth & Error Handling

**Key Pattern:**
```dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  dio.interceptors.add(
    QueuedInterceptor( // Sequential processing, prevents race conditions
      onRequest: (options, handler) {
        final token = ref.watch(authTokenProvider);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Refresh token once, retry original request
          final newToken = await ref.refresh(authTokenProvider);
          error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          return handler.resolve(await dio.fetch(error.requestOptions));
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});
```

**Critical:** Use QueuedInterceptor to prevent token refresh race conditions; employ "one future" pattern to avoid multiple simultaneous refresh calls.

---

## 5. Firebase Initialization Best Practices

**Main Function Setup:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(child: MyApp()),
  );
}
```

**Multi-Environment:** Use separate Firebase projects per flavor (dev/staging/prod) to prevent data contamination.

**Auth State Listening:**
```dart
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
```

**Firestore & Analytics:** Enable automatically via FlutterFire CLI setup. Initialize core first; other services depend on it.

---

## 6. Environment Configuration

Use `dart-define` during build or `.env` file with `flutter_dotenv`:
```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

**Riverpod Integration:**
```dart
final environmentProvider = Provider<Environment>((ref) {
  const apiUrl = String.fromEnvironment('API_BASE_URL');
  return Environment(baseUrl: apiUrl);
});
```

---

## 7. Dependency Injection via Riverpod

Riverpod **is** the dependency injection container. No separate DI library needed:

- **Providers:** Define dependencies as global providers
- **Mocking:** Override providers in tests with `ProviderContainer`
- **Scoping:** Use `FamilyModifier` for feature-specific instances

```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dio: ref.watch(dioProvider),
    firebaseAuth: FirebaseAuth.instance,
  );
});
```

---

## Summary

Feature-first Clean Architecture with Riverpod is Flutter's modern standard. Use QueuedInterceptor for Dio; initialize Firebase early. Riverpod handles DI natively—no external container needed. Target latest package versions as listed above.

---

## Sources

- [Flutter Clean Architecture Overview](https://dev.to/marwamejri/flutter-clean-architecture-1-an-overview-project-structure-4bhf)
- [Feature-First vs Layer-First Architecture](https://dev.to/princetomarappdev/mastering-flutter-architecture-from-clean-to-feature-first-for-faster-scalable-development-4605)
- [Dio Token Refresh Best Practices](https://dev.to/7twilight/mastering-auth-in-flutter-with-dio-from-simple-access-tokens-to-a-refresh-flow-27cf)
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Riverpod Official Docs](https://riverpod.dev/)
- [pub.dev Package Pages](https://pub.dev/)
