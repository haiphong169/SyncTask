import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/result.dart';

class MessageRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const _conversationKey = 'conversations';
  static const _messageKey = 'messages';

  Future<Result<Stream<List<MessageModel>>>> conversationMessages(
    String conversationUid,
  ) async {
    try {
      final messageStream = _db
          .collection(_conversationKey)
          .doc(conversationUid)
          .collection(_messageKey)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return MessageModel.fromJson(doc.data(), doc.id, conversationUid);
            }).toList();
          });
      return Result.ok(messageStream);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> sendMessage(MessageModel message) async {
    try {
      await _db
          .collection(_conversationKey)
          .doc(message.conversationUid)
          .collection(_messageKey)
          .add(message.toJson());
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> deleteMessage(
    String messageUid,
    String conversationUid,
  ) async {
    try {
      await _db
          .collection(_conversationKey)
          .doc(conversationUid)
          .collection(_messageKey)
          .doc(messageUid)
          .delete();
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }
}
