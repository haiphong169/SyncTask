import 'package:project_collaboration_app/features/project/domain/entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> getTasksStream(String taskListUid);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String uid);
}
