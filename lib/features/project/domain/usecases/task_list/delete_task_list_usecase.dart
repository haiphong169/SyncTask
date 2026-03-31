import 'package:project_collaboration_app/features/project/domain/repositories/task_list_repository.dart';

class DeleteTaskListUseCase {
  final TaskListRepository _taskListRepository;

  const DeleteTaskListUseCase({required TaskListRepository taskListRepository})
    : _taskListRepository = taskListRepository;

  Future<void> call(String taskListUid, String projectUid) {
    return _taskListRepository.deleteTaskList(taskListUid, projectUid);
  }
}
