import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

extension UserMapper on User {
  UserModel toModel() {
    return UserModel(uid: uid, username: username, avatar: avatar.toModel());
  }
}

extension AvatarMapper on Avatar {
  AvatarModel toModel() {
    return AvatarModel(
      backgroundColorValue: backgroundColorValue,
      textColorValue: textColorValue,
      initials: initials,
    );
  }
}

extension MessageMapper on Message {
  MessageModel toModel() {
    return MessageModel(
      uid: uid,
      conversationUid: conversationUid,
      senderUid: senderUid,
      text: text,
      createdAt: createdAt,
    );
  }
}
