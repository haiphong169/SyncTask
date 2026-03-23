import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/messaging/data/models/conversation_model.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class ConversationRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _conversationKey = 'conversations';

  Future<Result<Stream<List<ConversationModel>>>> getConversations(
    String userUid,
  ) async {
    try {
      final conversationStream = _db
          .collection(_conversationKey)
          .where('participants', arrayContains: userUid)
          .orderBy('lastMessageAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return ConversationModel.fromJson(doc.data(), doc.id);
            }).toList();
          });
      return Result.ok(conversationStream);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> addConversation(
    List<String> participants,
    String firstMessage,
    String userUid,
  ) async {
    try {
      final docRef = _db.collection(_conversationKey).doc();
      final conversation = ConversationModel(
        uid: docRef.id,
        participants: participants,
        lastMessage: firstMessage,
        lastMessageAt: DateTime.now(),
        lastMessageSenderUid: userUid,
      );
      await docRef.set(conversation.toJson());
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> deleteConversation(String conversationUid) async {
    try {
      await _db.collection(_conversationKey).doc(conversationUid).delete();
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> updateConversation(
    String conversationUid,
    MessageModel message,
  ) async {
    try {
      await _db.collection(_conversationKey).doc(conversationUid).update({
        'lastMessage': message.text,
        'lastMessageAt': Timestamp.fromDate(message.createdAt),
        'lastMessageSenderUid': message.senderUid,
      });
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }
}
