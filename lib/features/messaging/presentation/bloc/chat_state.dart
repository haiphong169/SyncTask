import 'package:equatable/equatable.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

abstract class ChatState extends Equatable {
  const ChatState(this.currentUser, this.partner);

  final User? currentUser;
  final User? partner;

  ChatState copyWithUsers({User? currentUser, User? partner});

  @override
  List<Object?> get props => [currentUser, partner];
}

class ChatLoading extends ChatState {
  const ChatLoading(super.currentUser, super.partner);

  @override
  ChatState copyWithUsers({User? currentUser, User? partner}) =>
      ChatLoading(currentUser ?? this.currentUser, partner ?? this.partner);
}

class ChatReady extends ChatState {
  final List<Message> messages;

  const ChatReady(super.currentUser, super.partner, {required this.messages});

  @override
  ChatState copyWithUsers({User? currentUser, User? partner}) => ChatReady(
    currentUser ?? this.currentUser,
    partner ?? this.partner,
    messages: messages,
  );

  @override
  List<Object?> get props => [messages, currentUser, partner];
}

// class ChatSending extends ChatReady {
//   final Message sentMessage;

//   const ChatSending({required super.display, required this.sentMessage});

//   @override
//   List<Object?> get props => [display, sentMessage];
// }

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error, super.currentUser, super.partner);

  @override
  ChatState copyWithUsers({User? currentUser, User? partner}) => ChatError(
    error,
    currentUser ?? this.currentUser,
    partner ?? this.partner,
  );

  @override
  List<Object?> get props => [error, currentUser, partner];
}

class ChatEmpty extends ChatState {
  const ChatEmpty(super.currentUser, super.partner);

  @override
  ChatState copyWithUsers({User? currentUser, User? partner}) =>
      ChatEmpty(currentUser ?? this.currentUser, partner ?? this.partner);
}
