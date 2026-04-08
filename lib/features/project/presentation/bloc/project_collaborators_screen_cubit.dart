import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/project/get_project_by_uid_usecase.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_users_by_uids_usecase.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ProjectCollaboratorsScreenCubit extends Cubit<UiState<List<User>>> {
  final String projectUid;
  final GetProjectByUidUseCase _getProjectByUid;
  final GetUsersByUidsUseCase _getUsersByUids;

  ProjectCollaboratorsScreenCubit({
    required this.projectUid,
    required GetProjectByUidUseCase getProjectByUid,
    required GetUsersByUidsUseCase getUsersByUids,
  }) : _getProjectByUid = getProjectByUid,
       _getUsersByUids = getUsersByUids,
       super(UiState.idle());

  Future<void> loadCollaborators() async {
    emit(UiState.loading());
    try {
      final project = await _getProjectByUid(projectUid);
      final members = project.members;
      final users = await _getUsersByUids(members);
      emit(UiState.success(users));
    } catch (e) {
      emit(UiState.error(e.toString()));
    }
  }
}
