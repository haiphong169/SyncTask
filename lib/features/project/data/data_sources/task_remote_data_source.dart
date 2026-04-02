import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/project/data/models/task_model.dart';

class TaskRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _projectCollection = 'projects';
  static const String _taskListCollection = 'task_lists';
  static const String _taskCollection = 'tasks';

  Future<void> createTask(TaskModel task) {
    return _db
        .collection(_projectCollection)
        .doc(task.projectUid)
        .collection(_taskListCollection)
        .doc(task.taskListUid)
        .collection(_taskCollection)
        .doc(task.uid)
        .set(task.toJson());
  }
}
