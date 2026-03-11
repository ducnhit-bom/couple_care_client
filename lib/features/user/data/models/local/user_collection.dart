import 'package:isar/isar.dart';

// Tên file sinh ra sẽ được build_runner quét
part 'user_collection.g.dart';

@collection
class UserCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String remoteId;
  late String name;
  late String email;
}
