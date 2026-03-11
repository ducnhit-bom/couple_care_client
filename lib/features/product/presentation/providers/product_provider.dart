import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product.dart';

part 'product_provider.g.dart';

@riverpod
class ProductController extends _$ProductController {
  @override
  FutureOr<List<Product>> build() async {
    return []; // Logic call repository ở đây
  }

  // Hàm để refresh danh sách (Pull to refresh)
  Future<void> refresh() async {
    // state = const AsyncLoading();
    // state = await AsyncValue.guard(
    //       () => ref.read(userRepositoryProvider).getUsers(),
    // );
  }
}
