import 'dart:async';

import 'package:project_collaboration_app/data/services/auth/firebase_auth_client.dart';
import 'package:project_collaboration_app/data/services/auth/hive_auth_client.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';
import 'package:project_collaboration_app/domain/models/user.dart';
import 'package:project_collaboration_app/utils/result.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuthClient firebaseAuthClient,
    required HiveAuthClient hiveClient,
  }) : _authClient = firebaseAuthClient,
       _hiveClient = hiveClient;

  final FirebaseAuthClient _authClient;
  final HiveAuthClient _hiveClient;
  User? _user;

  @override
  Future<User?> get user async {
    if (_user != null) {
      return _user!;
    }

    await _fetchUser();
    return _user;
  }

  Future<void> _fetchUser() async {
    final result = await _hiveClient.getUser();

    switch (result) {
      case Ok<User?>():
        _user = result.data;
      case Failure<User?>():
        _user = null;
    }
  }

  @override
  Future<Result<void>> login({
    String? email,
    String? password,
    bool signInWithGoogle = false,
  }) async {
    try {
      final result =
          signInWithGoogle
              ? await _authClient.signInWithGoogle()
              : await _authClient.login(email!, password!);
      switch (result) {
        case Ok<User>():
          _user = result.data;
          return await _hiveClient.saveUser(result.data);
        case Failure<User>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final result = await _authClient.logout();
      switch (result) {
        case Ok<void>():
          _user = null;
          return await _hiveClient.saveUser(null);
        case Failure<void>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final result = await _authClient.createNewUser(email, password, username);
      switch (result) {
        case Ok<User>():
          _user = result.data;
          return await _hiveClient.saveUser(result.data);
        case Failure<User>():
          return Result.failure(result.error);
      }
    } finally {
      notifyListeners();
    }
  }
}
