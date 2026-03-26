import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/repositories/session_provider_impl.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/add_conversation_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/check_existing_conversation_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/get_conversation_list_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/get_conversation_messages_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/send_message_usecase.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/search_user_use_case.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_user_use_case.dart';
import 'package:project_collaboration_app/features/messaging/data/data_sources/conversation_remote_data_source.dart';
import 'package:project_collaboration_app/features/messaging/data/data_sources/message_remote_data_source.dart';
import 'package:project_collaboration_app/features/messaging/data/repositories/conversation_repository_impl.dart';
import 'package:project_collaboration_app/features/messaging/data/repositories/message_repository_impl.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';

final repositoryProviders = [
  RepositoryProvider<AuthRemoteDataSource>(
    create: (context) => AuthRemoteDataSource(),
  ),
  RepositoryProvider<UserRemoteDataSource>(
    create: (context) => UserRemoteDataSource(),
  ),
  RepositoryProvider<UserLocalDataSource>(
    create: (context) => UserLocalDataSource(),
  ),
  RepositoryProvider<ConversationRemoteDataSource>(
    create: (context) => ConversationRemoteDataSource(),
  ),
  RepositoryProvider<MessageRemoteDataSource>(
    create: (context) => MessageRemoteDataSource(),
  ),

  RepositoryProvider<AuthRepository>(
    create:
        (context) => AuthRepositoryImpl(
          authRemoteDataSource: context.read<AuthRemoteDataSource>(),
        ),
  ),

  RepositoryProvider<SessionProvider>(
    create:
        (context) => SessionProviderImpl(
          userLocalDataSource: context.read<UserLocalDataSource>(),
        )..init(),
  ),

  RepositoryProvider<UserRepository>(
    create:
        (context) => UserRepositoryImpl(
          userRemoteDataSource: context.read<UserRemoteDataSource>(),
        ),
  ),
  RepositoryProvider<ConversationRepository>(
    create:
        (context) => ConversationRepositoryImpl(
          conversationRemoteDataSource:
              context.read<ConversationRemoteDataSource>(),
        ),
  ),
  RepositoryProvider<MessageRepository>(
    create:
        (context) => MessageRepositoryImpl(
          messageRemoteDataSource: context.read<MessageRemoteDataSource>(),
        ),
  ),
  RepositoryProvider<LoginUseCase>(
    create:
        (context) => LoginUseCase(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<SignInWithGoogleUseCase>(
    create:
        (context) => SignInWithGoogleUseCase(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<RegisterUseCase>(
    create:
        (context) => RegisterUseCase(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<LogoutUseCase>(
    create:
        (context) => LogoutUseCase(
          authRepository: context.read<AuthRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<SearchUserUseCase>(
    create:
        (context) =>
            SearchUserUseCase(userRepository: context.read<UserRepository>()),
  ),
  RepositoryProvider<GetUserUseCase>(
    create:
        (context) =>
            GetUserUseCase(sessionProvider: context.read<SessionProvider>()),
  ),
  RepositoryProvider<AddConversationUsecase>(
    create:
        (context) => AddConversationUsecase(
          conversationRepository: context.read<ConversationRepository>(),
          messageRepository: context.read<MessageRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<SendMessageUsecase>(
    create:
        (context) => SendMessageUsecase(
          messageRepository: context.read<MessageRepository>(),
          conversationRepository: context.read<ConversationRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<GetConversationMessagesUsecase>(
    create:
        (context) => GetConversationMessagesUsecase(
          messageRepository: context.read<MessageRepository>(),
        ),
  ),
  RepositoryProvider<GetConversationListUsecase>(
    create:
        (context) => GetConversationListUsecase(
          conversationRepository: context.read<ConversationRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<CheckExistingConversationUsecase>(
    create:
        (context) => CheckExistingConversationUsecase(
          conversationRepository: context.read<ConversationRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
];

final dataSourceProviders = [];

final blocProviders = [];
