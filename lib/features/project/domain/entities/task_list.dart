import 'package:equatable/equatable.dart';

class TaskList extends Equatable {
  final String uid;
  final String projectUid;
  final String name;
  final List<TaskHeader> taskHeaders;

  const TaskList({
    required this.uid,
    required this.projectUid,
    required this.name,
    required this.taskHeaders,
  });

  @override
  List<Object?> get props => [uid, projectUid, name, taskHeaders];
}

class TaskHeader extends Equatable {
  final String uid;
  final String name;
  final bool isCompleted;

  const TaskHeader({
    required this.uid,
    required this.name,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [uid, name, isCompleted];
}
