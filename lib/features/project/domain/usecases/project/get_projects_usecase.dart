import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/project/domain/entities/project.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';

class GetProjectsUseCase {
  final ProjectRepository _projectRepository;
  final SessionProvider _session;

  GetProjectsUseCase({
    required ProjectRepository projectRepository,
    required SessionProvider sessionProvider,
  }) : _projectRepository = projectRepository,
       _session = sessionProvider;

  Stream<List<Project>> call() {
    final userUid = _session.userUid;
    if (userUid == null) throw UserNotFoundException();

    return _projectRepository.getProjectsStream(userUid);
  }
}
