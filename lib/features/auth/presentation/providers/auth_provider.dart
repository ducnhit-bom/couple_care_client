import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/auth.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<List<Auth>> build() async {
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
