import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/router/router.dart';
// Import các file đã gen (đảm bảo đường dẫn đúng với project của bạn)
import 'features/user/data/models/local/user_collection.dart';

// Khai báo provider cho Isar để dùng ở các layer khác
final isarProvider = Provider<Isar>((ref) => throw UnimplementedError());

void main() async {
  // 1. Đảm bảo Flutter đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Local Database (Isar)
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [UserCollectionSchema], // Schema được tạo ra từ Isar Generator
    directory: dir.path,
  );

  runApp(
    // 3. ProviderScope: Nơi lưu trữ toàn bộ State của ứng dụng
    ProviderScope(
      overrides: [
        // Inject instance isar vào provider để các Repository có thể dùng
        isarProvider.overrideWithValue(isar),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy config router từ provider
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Clean Architecture Flutter',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // home: const Scaffold(
      //   body: Center(child: Text('Hệ thống đã sẵn sàng!')),
      // ),
      routerConfig: router, // Kết nối GoRouter vào App
    );
  }
}
