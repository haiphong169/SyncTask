import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final String uid;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageAt;
  final String lastMessageSenderUid;

  const Conversation({
    required this.uid,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastMessageSenderUid,
  });

  @override
  List<Object?> get props => [
    uid,
    participants,
    lastMessage,
    lastMessageAt,
    lastMessageSenderUid,
  ];
}
