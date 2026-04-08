import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';

class InviteUserUseCase {
  final ProjectRepository _projectRepository;

  const InviteUserUseCase({required ProjectRepository projectRepository})
    : _projectRepository = projectRepository;

  Future<void> call({required String userUid, required String projectUid}) {
    return _projectRepository.inviteUser(
      userUid: userUid,
      projectUid: projectUid,
    );
  }
}
