import 'package:equatable/equatable.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatReady extends ChatState {
  final List<Message> messages;

  const ChatReady({required this.messages});

  @override
  List<Object?> get props => [messages];

  ChatReady copyWith({List<Message>? messages}) {
    return ChatReady(messages: messages ?? this.messages);
  }
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  @override
  List<Object?> get props => [error];
}

class ChatEmpty extends ChatState {
  const ChatEmpty();
}
