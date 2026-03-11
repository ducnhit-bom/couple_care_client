import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/user/presentation/pages/user_list_page.dart';

part 'router.g.dart';

// Dùng Riverpod để cung cấp GoRouter instance
@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true, // Senior tip: bật log để dễ debug route
    routes: [
      // Trang chủ - Danh sách User
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const UserListPage(),
      ),

      GoRoute(
        path: '/product',
        name: 'product',
        builder: (context, state) => const ProductPage(),
      ),

      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),

      // Ví dụ Route cho trang chi tiết User (với tham số ID)
      /*
      GoRoute(
        path: '/user/:id',
        name: 'user_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UserDetailPage(userId: id);
        },
      ),
      */
    ],
    // Xử lý lỗi khi không tìm thấy trang
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
}
