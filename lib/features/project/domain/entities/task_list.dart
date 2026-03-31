import 'package:equatable/equatable.dart';

class TaskList extends Equatable {
  final String uid;
  final String projectUid;
  final String name;

  const TaskList({
    required this.uid,
    required this.projectUid,
    required this.name,
  });

  @override
  List<Object?> get props => [uid, projectUid, name];
}
