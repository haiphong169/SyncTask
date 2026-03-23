import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String uid;
  final String conversationUid;
  final String senderUid;
  final String text;
  final DateTime createdAt;

  const Message({
    required this.uid,
    required this.conversationUid,
    required this.senderUid,
    required this.text,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [uid, conversationUid, senderUid, text, createdAt];
}
