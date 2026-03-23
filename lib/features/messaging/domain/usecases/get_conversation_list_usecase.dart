import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class GetConversationListUsecase {
  final ConversationRepository _conversationRepository;

  const GetConversationListUsecase({
    required ConversationRepository conversationRepository,
  }) : _conversationRepository = conversationRepository;

  Future<Result<Stream<List<Conversation>>>> call() {
    return _conversationRepository.conversations;
  }
}
