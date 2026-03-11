import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/product_provider.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lắng nghe trạng thái của product
    final productAsync = ref.watch(productControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(productControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: productAsync.when(
        data: (users) => Center(child: Text('Product Page')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Đã có lỗi xảy ra: $err')),
      ),
    );
  }
}
