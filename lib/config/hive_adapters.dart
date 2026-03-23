import 'package:hive/hive.dart';
import 'package:project_collaboration_app/features/messaging/data/models/conversation_model.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';

void addHiveAdapters() {
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(AvatarModelAdapter());
  Hive.registerAdapter(ConversationModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());
}
