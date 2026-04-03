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
  @HiveField(3)
  final bool isArchived;
  @HiveField(4)
  final Map<String, TaskHeaderModel> taskHeaders;

  const TaskListModel({
    required this.uid,
    required this.projectUid,
    required this.name,
    required this.isArchived,
    required this.taskHeaders,
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
      isArchived: map['isArchived'] as bool,
      taskHeaders: (map['taskHeaders'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          TaskHeaderModel.fromJson(value as Map<String, dynamic>, key),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isArchived': isArchived,
      'taskHeaders': taskHeaders.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  TaskList toEntity() {
    return TaskList(
      uid: uid,
      projectUid: projectUid,
      name: name,
      isArchived: isArchived,
      taskHeaders: taskHeaders.map(
        (key, value) => MapEntry(key, value.toEntity()),
      ),
    );
  }
}

@HiveType(typeId: 7)
class TaskHeaderModel {
  @HiveField(0)
  final String taskUid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isCompleted;

  const TaskHeaderModel({
    required this.taskUid,
    required this.name,
    required this.isCompleted,
  });

  factory TaskHeaderModel.fromJson(Map<String, dynamic> map, String taskUid) {
    return TaskHeaderModel(
      taskUid: taskUid,
      name: map['name'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'isCompleted': isCompleted};
  }

  TaskHeader toEntity() {
    return TaskHeader(taskUid: taskUid, name: name, isCompleted: isCompleted);
  }
}
