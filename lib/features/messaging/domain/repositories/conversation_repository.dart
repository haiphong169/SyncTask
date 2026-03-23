import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/utils/result.dart';

abstract class ConversationRepository {
  Future<Result<Stream<List<Conversation>>>> get conversations;
  Future<VoidResult> addConversation(
    List<String> participants,
    String firstMessage,
  );
  Future<VoidResult> deleteConversation(String conversationUid);
  Future<VoidResult> updateConversation(
    String conversationUid,
    Message newLastMessage,
  );
}
