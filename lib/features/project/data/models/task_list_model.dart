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
  final List<TaskHeaderModel> taskHeaders;

  const TaskListModel({
    required this.uid,
    required this.projectUid,
    required this.name,
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
      taskHeaders:
          (map['taskHeaders'] as List<dynamic>)
              .map(
                (item) =>
                    TaskHeaderModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'taskHeaders': taskHeaders.map((header) => header.toJson()).toList(),
    };
  }

  TaskList toEntity() {
    return TaskList(
      uid: uid,
      projectUid: projectUid,
      name: name,
      taskHeaders:
          taskHeaders.map((taskHeader) => taskHeader.toEntity()).toList(),
    );
  }
}

@HiveType(typeId: 7)
class TaskHeaderModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isCompleted;

  const TaskHeaderModel({
    required this.uid,
    required this.name,
    required this.isCompleted,
  });

  factory TaskHeaderModel.fromJson(Map<String, dynamic> map) {
    return TaskHeaderModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'isCompleted': isCompleted};
  }

  TaskHeader toEntity() {
    return TaskHeader(uid: uid, name: name, isCompleted: isCompleted);
  }
}
