import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/user_repositories.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

part 'user_repository_impl.g.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<List<User>> getUsers() async {
    // Giả lập độ trễ network 1.5 giây
    await Future.delayed(const Duration(milliseconds: 1500));

    // Hardcode data response theo đúng chuẩn JSON từ server
    final mockData = [
      {'id': '1', 'name': 'Gemini AI', 'email': 'gemini@google.com'},
      {'id': '2', 'name': 'Flutter Senior', 'email': 'senior@dart.dev'},
      {'id': '3', 'name': 'Riverpod Expert', 'email': 'expert@riverpod.org'},
      ...List.generate(97, (index) {
        final id = index + 4;
        return {
          'id': id.toString(),
          'name': 'User Number $id',
          'email': 'user$id@example.com',
        };
      }),
    ];

    // Map content to UserModel then to Entity
    return mockData.map((json) => UserModel.fromJson(json).toEntity()).toList();
  }
}

// Provider để inject repository
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepositoryImpl();
}
