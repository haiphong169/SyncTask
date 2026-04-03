import 'package:project_collaboration_app/features/project/domain/repositories/task_list_repository.dart';

class ArchiveTaskListUseCase {
  final TaskListRepository _taskListRepository;

  const ArchiveTaskListUseCase({required TaskListRepository taskListRepository})
    : _taskListRepository = taskListRepository;

  Future<void> call(String projectUid, String taskListUid, bool isArchived) {
    return _taskListRepository.updateTaskListFields(projectUid, taskListUid, {
      'isArchived': isArchived,
    });
  }
}
