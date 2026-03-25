import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/type_def.dart';

abstract class MessageRepository {
  Future<Result<MessageStream>> conversationMessages(String conversationUid);
  Future<VoidResult> sendMessage(Message message);
  Future<VoidResult> deleteMessage(String messageUid);
}
