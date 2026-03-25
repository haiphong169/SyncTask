import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';

abstract class ChatEvent {}

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
