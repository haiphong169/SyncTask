import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

abstract class ChatEvent {}

class Initialization extends ChatEvent {}

class MessageSent extends ChatEvent {
  final String text;

  MessageSent(this.text);
}

class ConversationCreated extends ChatEvent {
  final String text;

  ConversationCreated(this.text);
}

class MessageUpdated extends ChatEvent {
  final List<Message> messages;

  MessageUpdated(this.messages);
}

class MessageError extends ChatEvent {
  final String message;

  MessageError(this.message);
}

class UsersUpdated extends ChatEvent {
  final User currentUser;
  final User partner;

  UsersUpdated(this.currentUser, this.partner);
}
