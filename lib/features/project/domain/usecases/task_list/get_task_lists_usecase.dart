import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_list_repository.dart';

class GetTaskListsUseCase {
  final TaskListRepository _taskListRepository;

  const GetTaskListsUseCase({required TaskListRepository taskListRepository})
    : _taskListRepository = taskListRepository;

  Stream<List<TaskList>> call(String projectUid) {
    return _taskListRepository.getTaskLists(projectUid);
  }
}
