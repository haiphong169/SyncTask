import 'package:hive/hive.dart';
import 'package:project_collaboration_app/domain/models/user.dart';

void addHiveAdapters() {
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AvatarAdapter());
}
