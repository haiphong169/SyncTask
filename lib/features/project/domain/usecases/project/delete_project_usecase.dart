import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';

class DeleteProjectUsecase {
  final ProjectRepository _projectRepository;

  DeleteProjectUsecase({required ProjectRepository projectRepository})
    : _projectRepository = projectRepository;

  Future<void> call(String uid) async {
    return await _projectRepository.deleteProject(uid);
  }
}
