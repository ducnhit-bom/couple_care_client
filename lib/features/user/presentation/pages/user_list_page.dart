import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_list_provider.dart';

class UserListPage extends ConsumerWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lắng nghe trạng thái của list user
    final userListAsync = ref.watch(userListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(userListControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: userListAsync.when(
        data: (users) => RefreshIndicator(
          onRefresh: () =>
              ref.read(userListControllerProvider.notifier).refresh(),
          child: ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: GestureDetector(
                  onTap: () {
                    context.pushNamed('auth', pathParameters: {});
                  },
                  child: CircleAvatar(child: Text(user.name[0])),
                ),
                title: GestureDetector(
                  onTap: () {
                    context.pushNamed('product');
                  },
                  child: Text(user.name),
                ),
                subtitle: Text(user.email),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Đã có lỗi xảy ra: $err')),
      ),
    );
  }
}
