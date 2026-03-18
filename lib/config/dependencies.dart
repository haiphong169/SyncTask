import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/data/repositories/auth/auth_repository_impl.dart';
import 'package:project_collaboration_app/data/services/auth/firebase_auth_client.dart';
import 'package:project_collaboration_app/data/services/auth/hive_auth_client.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';

final repositoryProviders = [
  RepositoryProvider<HiveAuthClient>(create: (_) => HiveAuthClient()),
  RepositoryProvider<FirebaseAuthClient>(create: (_) => FirebaseAuthClient()),
  RepositoryProvider<AuthRepository>(
    create:
        (context) => AuthRepositoryImpl(
          firebaseAuthClient: context.read(),
          hiveClient: context.read(),
        ),
  ),
];

final blocProviders = [];
