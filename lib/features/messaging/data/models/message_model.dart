import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';

part 'message_model.g.dart';

@HiveType(typeId: 3)
class MessageModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String conversationUid;
  @HiveField(2)
  final String senderUid;
  @HiveField(3)
  final String text;
  @HiveField(4)
  final DateTime createdAt;

  MessageModel({
    required this.uid,
    required this.conversationUid,
    required this.senderUid,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json,
    String messageUid,
    String conversationUid,
  ) {
    return MessageModel(
      uid: messageUid,
      conversationUid: conversationUid,
      senderUid: json['senderUid'] as String,
      text: json['text'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderUid': senderUid,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Message toEntity() {
    return Message(
      uid: uid,
      conversationUid: conversationUid,
      senderUid: senderUid,
      text: text,
      createdAt: createdAt,
    );
  }
}
