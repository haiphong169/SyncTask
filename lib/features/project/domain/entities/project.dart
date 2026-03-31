import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String uid;
  final String name;
  final int backgroundColorValue;
  final List<String> members;

  const Project({
    required this.uid,
    required this.name,
    required this.backgroundColorValue,
    required this.members,
  });

  @override
  List<Object?> get props => [uid, name, backgroundColorValue, members];
}
