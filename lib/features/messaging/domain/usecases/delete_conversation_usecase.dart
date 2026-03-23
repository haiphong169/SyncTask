import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class DeleteConversationUsecase {
  final ConversationRepository _conversationRepository;

  const DeleteConversationUsecase({
    required ConversationRepository conversationRepository,
  }) : _conversationRepository = conversationRepository;

  Future<VoidResult> call(String conversationUid) {
    return _conversationRepository.deleteConversation(conversationUid);
  }
}
