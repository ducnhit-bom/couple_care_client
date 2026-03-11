import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user.dart';
import '../../data/repositories/user_repository_impl.dart';

part 'user_list_provider.g.dart';

@riverpod
class UserListController extends _$UserListController {
  @override
  FutureOr<List<User>> build() {
    // Gọi repository để lấy dữ liệu ngay khi khởi tạo
    return ref.watch(userRepositoryProvider).getUsers();
  }

  // Hàm để refresh danh sách (Pull to refresh)
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).getUsers(),
    );
  }
}
