import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_list_repository.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

class AddTaskUseCase {
  final TaskRepository _taskRepository;
  final TaskListRepository _taskListRepository;

  const AddTaskUseCase({
    required TaskRepository taskRepository,
    required TaskListRepository taskListRepository,
  }) : _taskRepository = taskRepository,
       _taskListRepository = taskListRepository;

  Future<void> call(
    String projectUid,
    String taskListUid,
    List<TaskHeader> headers,
    String name,
  ) async {
    final newTask = Task(
      uid: Uuid().v4(),
      taskListUid: taskListUid,
      projectUid: projectUid,
      name: name,
      isCompleted: false,
    );
    final newHeaders = [
      ...headers,
      TaskHeader(uid: newTask.uid, name: name, isCompleted: false),
    ];
    await _taskRepository.createTask(newTask);
    return _taskListRepository.updateTaskList(
      projectUid,
      taskListUid,
      newHeaders,
    );
  }
}
