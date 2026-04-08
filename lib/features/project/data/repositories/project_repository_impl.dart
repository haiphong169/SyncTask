import 'package:project_collaboration_app/features/project/data/data_sources/project_remote_data_source.dart';
import 'package:project_collaboration_app/features/project/domain/entities/project.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource _projectRemoteDataSource;

  ProjectRepositoryImpl({
    required ProjectRemoteDataSource projectRemoteDataSource,
  }) : _projectRemoteDataSource = projectRemoteDataSource;

  @override
  Stream<List<Project>> getProjectsStream(String userUid) async* {
    final modelStream = _projectRemoteDataSource.getProjectsStream(userUid);

    yield* modelStream.map(
      (modelList) => modelList.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> createProject(Project project) async {
    await _projectRemoteDataSource.addProject(project.toModel());
  }

  @override
  Future<void> deleteProject(String uid) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProject(Project project) async {
    throw UnimplementedError();
  }

  @override
  Future<void> inviteUser({
    required String userUid,
    required String projectUid,
  }) {
    return _projectRemoteDataSource.inviteUser(
      userUid: userUid,
      projectUid: projectUid,
    );
  }
}
