import 'package:project_collaboration_app/features/project/domain/entities/task.dart';

abstract class TaskRepository {
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String projectUid, String taskListUid, String uid);
}
