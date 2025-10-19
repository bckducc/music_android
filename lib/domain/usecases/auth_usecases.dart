import 'package:trainning/domain/entities/app_user.dart';
import 'package:trainning/domain/repositories/auth_repository.dart';

class WatchAuthState {
  final AuthRepository repository;
  WatchAuthState(this.repository);
  Stream<AppUser?> call() => repository.authStateChanges();
}

class GetCurrentUser {
  final AuthRepository repository;
  GetCurrentUser(this.repository);
  Future<AppUser?> call() => repository.currentUser();
}

class SignInWithEmail {
  final AuthRepository repository;
  SignInWithEmail(this.repository);
  Future<AppUser> call(String email, String password) =>
      repository.signInWithEmail(email, password);
}

class RegisterWithEmail {
  final AuthRepository repository;
  RegisterWithEmail(this.repository);
  Future<AppUser> call(String email, String password) =>
      repository.registerWithEmail(email, password);
}

class SignOut {
  final AuthRepository repository;
  SignOut(this.repository);
  Future<void> call() => repository.signOut();
}


