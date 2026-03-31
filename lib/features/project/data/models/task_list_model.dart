import 'package:hive/hive.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';

part 'task_list_model.g.dart';

@HiveType(typeId: 5)
class TaskListModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String projectUid;
  @HiveField(2)
  final String name;

  const TaskListModel({
    required this.uid,
    required this.projectUid,
    required this.name,
  });

  factory TaskListModel.fromJson(
    Map<String, dynamic> map,
    String uid,
    String projectUid,
  ) {
    return TaskListModel(
      uid: uid,
      projectUid: projectUid,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  TaskList toEntity() {
    return TaskList(
      uid: uid,
      projectUid: projectUid,
      name: name,
    );
  }
}
