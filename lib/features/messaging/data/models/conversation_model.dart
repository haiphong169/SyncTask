import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';

part 'conversation_model.g.dart';

@HiveType(typeId: 2)
class ConversationModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final List<String> participants;
  @HiveField(2)
  final String lastMessage;
  @HiveField(3)
  final DateTime lastMessageAt;
  @HiveField(4)
  final String lastMessageSenderUid;

  const ConversationModel({
    required this.uid,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastMessageSenderUid,
  });

  factory ConversationModel.fromJson(
    Map<String, dynamic> json,
    String conversationUid,
  ) {
    return ConversationModel(
      uid: conversationUid,
      participants: List<String>.from(json['participants'] as List<dynamic>),
      lastMessage: json['lastMessage'] as String,
      lastMessageAt: (json['lastMessageAt'] as Timestamp).toDate(),
      lastMessageSenderUid: json['lastMessageSenderUid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageAt': Timestamp.fromDate(lastMessageAt),
      'lastMessageSenderUid': lastMessageSenderUid,
    };
  }

  Conversation toEntity() {
    return Conversation(
      uid: uid,
      participants: participants,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
      lastMessageSenderUid: lastMessageSenderUid,
    );
  }
}
