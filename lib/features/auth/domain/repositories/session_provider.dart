import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

abstract class SessionProvider {
  Future<User?> get user;
  Future<String?> get userUid;
}
