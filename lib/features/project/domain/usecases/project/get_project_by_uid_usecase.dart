import 'package:project_collaboration_app/features/project/domain/entities/project.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';

class GetProjectByUidUseCase {
  final ProjectRepository _projectRepository;

  GetProjectByUidUseCase(this._projectRepository);

  Future<Project> call(String projectUid) {
    return _projectRepository.getProjectById(projectUid);
  }
}
