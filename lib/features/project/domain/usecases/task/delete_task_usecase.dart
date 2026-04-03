import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository _taskRepository;

  DeleteTaskUseCase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  Future<void> call(String projectUid, String taskListUid, String uid) {
    return _taskRepository.deleteTask(projectUid, taskListUid, uid);
  }
}
