import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String uid;
  final String taskListUid;
  final String projectUid;
  final String name;
  final bool isCompleted;

  const Task({
    required this.uid,
    required this.taskListUid,
    required this.projectUid,
    required this.name,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [uid, taskListUid, projectUid, name, isCompleted];

  Task copyWith({
    String? uid,
    String? taskListUid,
    String? projectUid,
    String? name,
    bool? isCompleted,
  }) {
    return Task(
      uid: uid ?? this.uid,
      taskListUid: taskListUid ?? this.taskListUid,
      projectUid: projectUid ?? this.projectUid,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
