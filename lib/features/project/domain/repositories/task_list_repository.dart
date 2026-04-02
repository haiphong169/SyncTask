import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';

abstract class TaskListRepository {
  Stream<List<TaskList>> getTaskLists(String projectUid);
  Future<void> createTaskList(TaskList taskList);
  Future<void> updateTaskList(
    String projectUid,
    String taskListUid,
    List<TaskHeader> newHeaders,
  );
  Future<void> deleteTaskList(String taskListUid, String projectUid);
}
