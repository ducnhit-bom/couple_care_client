import '../entities/auth.dart';

abstract class AuthRepository {
Future<List<Auth>> getAuths();
}