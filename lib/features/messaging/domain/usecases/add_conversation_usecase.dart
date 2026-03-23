import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class AddConversationUsecase {
  final ConversationRepository _conversationRepository;

  const AddConversationUsecase({
    required ConversationRepository conversationRepository,
  }) : _conversationRepository = conversationRepository;

  Future<VoidResult> call(List<String> participants, String firstMessage) {
    return _conversationRepository.addConversation(participants, firstMessage);
  }
}
