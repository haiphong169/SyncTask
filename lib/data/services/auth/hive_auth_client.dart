import 'package:hive/hive.dart';
import 'package:project_collaboration_app/domain/models/user.dart';
import 'package:project_collaboration_app/utils/result.dart';

class HiveAuthClient {
  static const _authBox = 'auth_box';
  static const _userKey = 'user';

  Future<Box<User?>> _openBox() async {
    if (Hive.isBoxOpen(_authBox)) {
      return Hive.box<User?>(_authBox);
    }
    return await Hive.openBox<User?>(_authBox);
  }

  Future<Result<User?>> getUser() async {
    try {
      final box = await _openBox();
      return Result.ok(box.get(_userKey));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<void>> saveUser(User? user) async {
    try {
      final box = await _openBox();
      return Result.ok(box.put(_userKey, user));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
