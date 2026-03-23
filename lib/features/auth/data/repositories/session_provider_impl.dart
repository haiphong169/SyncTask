import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/utils/result.dart';

class SessionProviderImpl implements SessionProvider {
  final UserLocalDataSource _userLocalDataSource;

  SessionProviderImpl({required UserLocalDataSource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;

  User? _user;

  @override
  Future<User?> get user async {
    if (_user != null) {
      return _user!;
    }

    await _fetchUser();
    return _user;
  }

  @override
  Future<String?> get userUid async {
    final currentUser = await user;
    return currentUser?.uid;
  }

  Future<void> _fetchUser() async {
    final result = await _userLocalDataSource.getUser();

    switch (result) {
      case Ok<UserModel?>():
        _user = result.data?.toEntity();
      case Failure<UserModel?>():
        _user = null;
    }
  }
}
