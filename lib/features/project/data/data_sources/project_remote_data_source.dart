import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/project/data/models/project_model.dart';

class ProjectRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _projectsCollection = 'projects';

  Stream<List<ProjectModel>> getProjectsStream(String userUid) {
    final projectStream = _db
        .collection(_projectsCollection)
        .where('members', arrayContains: userUid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ProjectModel.fromJson(doc.data(), doc.id);
          }).toList();
        });
    return projectStream;
  }

  Future<void> addProject(ProjectModel project) async {
    await _db
        .collection(_projectsCollection)
        .doc(project.uid)
        .set(project.toJson());
  }

  Future<void> deleteProject(String projectUid) async {
    await _db.collection(_projectsCollection).doc(projectUid).delete();
  }
}
