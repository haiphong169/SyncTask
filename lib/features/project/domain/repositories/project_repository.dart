import 'package:project_collaboration_app/features/project/domain/entities/project.dart';

abstract class ProjectRepository {
  Stream<List<Project>> getProjectsStream(String userUid);
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String uid);
}
