import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends Equatable {
  const User({required this.uid, required this.username, required this.avatar});

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final Avatar avatar;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'avatar': avatar.toJson(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    uid: json['uid'] as String,
    username: json['username'] as String,
    avatar: Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
  );

  @override
  List<Object?> get props => [uid, username, avatar];
}

@HiveType(typeId: 1)
class Avatar extends Equatable {
  const Avatar({
    required this.backgroundColor,
    required this.initials,
    required this.textColor,
  });

  @HiveField(0)
  final int backgroundColor;
  @HiveField(1)
  final String initials;
  @HiveField(2)
  final int textColor;

  Map<String, dynamic> toJson() => {
    'backgroundColor': backgroundColor,
    'usernameAvatarText': initials,
    'textColor': textColor,
  };

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    backgroundColor: json['backgroundColor'] as int,
    initials: json['usernameAvatarText'] as String,
    textColor: json['textColor'] as int,
  );

  @override
  List<Object?> get props => [backgroundColor, initials, textColor];
}
