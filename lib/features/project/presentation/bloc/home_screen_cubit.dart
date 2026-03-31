import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/entities/project.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/project/get_projects_usecase.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class HomeScreenCubit extends Cubit<UiState<List<Project>>> {
  HomeScreenCubit({required GetProjectsUseCase getProjectsUseCase})
    : _getProjectsUseCase = getProjectsUseCase,
      super(UiState.idle());

  final GetProjectsUseCase _getProjectsUseCase;
  StreamSubscription? _subscription;

  void fetchProjects() {
    emit(UiState.loading());
    try {
      final projectsStream = _getProjectsUseCase();
      _subscription?.cancel();
      _subscription = projectsStream.listen(
        (projects) => emit(UiState.success(projects)),
        onError: (e) => emit(UiState.error(e.toString())),
      );
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
