import 'package:project_collaboration_app/features/messaging/data/data_sources/message_remote_data_source.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/type_def.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource _messageRemoteDataSource;

  MessageRepositoryImpl({
    required MessageRemoteDataSource messageRemoteDataSource,
  }) : _messageRemoteDataSource = messageRemoteDataSource;

  @override
  Future<Result<MessageStream>> conversationMessages(
    String conversationUid,
  ) async {
    final result = await _messageRemoteDataSource.conversationMessages(
      conversationUid,
    );
    switch (result) {
      case Ok<Stream<List<MessageModel>>>():
        return Result.ok(
          result.data.map(
            (modelList) => modelList.map((model) => model.toEntity()).toList(),
          ),
        );
      case Failure<Stream<List<MessageModel>>>():
        return Result.failure(result.error);
    }
  }

  @override
  Future<VoidResult> deleteMessage(String messageUid) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }

  @override
  Future<VoidResult> sendMessage(Message message) {
    return _messageRemoteDataSource.sendMessage(message.toModel());
  }
}
