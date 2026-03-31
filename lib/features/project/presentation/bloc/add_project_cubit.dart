import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/project/add_project_usecase.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class AddProjectCubit extends Cubit<VoidUiState> {
  final AddProjectUseCase _addProject;

  AddProjectCubit({required AddProjectUseCase addProjectUseCase})
    : _addProject = addProjectUseCase,
      super(VoidUiState.idle());

  void addProject(String projectName, int backgroundColorValue) async {
    emit(VoidUiState.loading());
    try {
      await _addProject(projectName, backgroundColorValue);
      emit(VoidUiState.success(null));
    } on AppException catch (appException) {
      emit(VoidUiState.error(appException.message));
    } on Exception catch (e) {
      emit(VoidUiState.error(e.toString()));
    }
  }
}
