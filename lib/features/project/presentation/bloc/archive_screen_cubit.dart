import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/archive_task_list_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/get_task_lists_usecase.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ArchiveScreenCubit extends Cubit<UiState<List<TaskList>>> {
  ArchiveScreenCubit({
    required this.projectUid,
    required GetTaskListsUseCase getTaskListUseCase,
    required ArchiveTaskListUseCase archiveTaskListUseCase,
  }) : _getTaskList = getTaskListUseCase,
       _archiveTaskList = archiveTaskListUseCase,
       super(UiState.idle());

  final GetTaskListsUseCase _getTaskList;
  final ArchiveTaskListUseCase _archiveTaskList;
  StreamSubscription? _archivedTaskListSubscription;
  final String projectUid;

  void fetchArchivedTaskLists() {
    emit(UiState.loading());
    try {
      final taskListsStream = _getTaskList(projectUid);
      _archivedTaskListSubscription?.cancel();
      _archivedTaskListSubscription = taskListsStream.listen(
        (taskLists) => emit(
          UiState.success(
            taskLists.where((taskList) => taskList.isArchived).toList(),
          ),
        ),
        onError: (e) => emit(UiState.error(e.toString())),
      );
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void restoreTaskList(String taskListUid) {
    try {
      _archiveTaskList(projectUid, taskListUid, false);
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _archivedTaskListSubscription?.cancel();
    return super.close();
  }
}
