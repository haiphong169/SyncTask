import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';

class DeleteMessageUsecase {
  final MessageRepository _messageRepository;

  const DeleteMessageUsecase({required MessageRepository messageRepository})
    : _messageRepository = messageRepository;

  Future<VoidResult> call(String messageUid) {
    return _messageRepository.deleteMessage(messageUid);
  }
}
