import 'package:project_collaboration_app/features/messaging/data/data_sources/conversation_remote_data_source.dart';
import 'package:project_collaboration_app/features/messaging/data/models/conversation_model.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';
import 'package:project_collaboration_app/utils/result.dart';

class ConversationRepositoryImpl extends ConversationRepository {
  final ConversationRemoteDataSource _conversationRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;

  ConversationRepositoryImpl({
    required ConversationRemoteDataSource conversationRemoteDataSource,
    required UserLocalDataSource userLocalDataSource,
  }) : _conversationRemoteDataSource = conversationRemoteDataSource,
       _userLocalDataSource = userLocalDataSource;

  @override
  Future<VoidResult> addConversation(
    List<String> participants,
    String firstMessage,
  ) async {
    final currentUserResult = await _userLocalDataSource.getUser();
    switch (currentUserResult) {
      case Ok<UserModel?>():
        return _conversationRemoteDataSource.addConversation(
          participants,
          firstMessage,
          currentUserResult.data!.uid,
        );
      case Failure<UserModel?>():
        return Result.failure(currentUserResult.error);
    }
  }

  @override
  Future<Result<Stream<List<Conversation>>>> get conversations async {
    final currentUserResult = await _userLocalDataSource.getUser();
    switch (currentUserResult) {
      case Ok<UserModel?>():
        // todo fix this later
        final uid = currentUserResult.data!.uid;
        final result = await _conversationRemoteDataSource.getConversations(
          uid,
        );
        switch (result) {
          case Ok<Stream<List<ConversationModel>>>():
            return Result.ok(
              result.data.map(
                (modelList) =>
                    modelList.map((model) => model.toEntity()).toList(),
              ),
            );
          case Failure<Stream<List<ConversationModel>>>():
            return Result.failure(result.error);
        }

      case Failure<UserModel?>():
        return Result.failure(currentUserResult.error);
    }
  }

  @override
  Future<VoidResult> deleteConversation(String conversationUid) {
    return _conversationRemoteDataSource.deleteConversation(conversationUid);
  }

  @override
  Future<VoidResult> updateConversation(
    String conversationUid,
    Message newLastMessage,
  ) {
    final messageModel = newLastMessage.toModel();
    return _conversationRemoteDataSource.updateConversation(
      conversationUid,
      messageModel,
    );
  }
}
