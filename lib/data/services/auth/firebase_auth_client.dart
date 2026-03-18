import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_collaboration_app/domain/models/user.dart' as app_user;
import 'package:project_collaboration_app/utils/generate_default_avatar.dart';
import 'package:project_collaboration_app/utils/logger.dart';
import 'package:project_collaboration_app/utils/result.dart';

class FirebaseAuthClient {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Result<app_user.User>> createNewUser(
    String email,
    String password,
    String username,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger().d(credential.toString());
      final user = app_user.User(
        uid: credential.user!.uid,
        username: username,
        avatar: AvatarGenerator.generateDefaultAvatar(username),
      );
      _db.collection('users').doc(user.uid).set(user.toJson());
      return Result.ok(user);
    } on Exception catch (e) {
      AppLogger().e(e);
      return Result.failure(e);
    }
  }

  Future<Result<app_user.User>> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userDoc =
          await _db.collection('users').doc(credential.user!.uid).get();

      final user = app_user.User.fromJson(
        userDoc.data() as Map<String, dynamic>,
      );
      return Result.ok(user);
    } on Exception catch (e) {
      AppLogger().e(e);
      return Result.failure(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<app_user.User>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      final user = app_user.User(
        uid: result.user!.uid,
        username: googleUser.displayName!,
        avatar: AvatarGenerator.generateDefaultAvatar(googleUser.displayName!),
      );
      _db.collection('users').doc(user.uid).set(user.toJson());
      return Result.ok(user);
    } on Exception catch (e) {
      AppLogger().e(e);
      AppLogger().e(e.runtimeType);
      return Result.failure(e);
    }
  }
}
