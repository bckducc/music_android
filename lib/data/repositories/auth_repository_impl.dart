import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:trainning/domain/entities/app_user.dart';
import 'package:trainning/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth auth;
  AuthRepositoryImpl(this.auth);

  AppUser? _mapUser(fb.User? user) =>
      user == null ? null : AppUser(uid: user.uid, email: user.email);

  @override
  Stream<AppUser?> authStateChanges() =>
      auth.authStateChanges().map(_mapUser);

  @override
  Future<AppUser?> currentUser() async => _mapUser(auth.currentUser);

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    final cred = await auth.signInWithEmailAndPassword(
        email: email, password: password);
    return _mapUser(cred.user)!;
  }

  @override
  Future<AppUser> registerWithEmail(String email, String password) async {
    final cred = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _mapUser(cred.user)!;
  }

  @override
  Future<void> signOut() => auth.signOut();
}


