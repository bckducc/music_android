import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainning/domain/entities/app_user.dart';
import 'package:trainning/domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final WatchAuthState watchAuthState;
  final SignInWithEmail signIn;
  final RegisterWithEmail register;
  final SignOut signOut;

  AuthBloc({
    required this.watchAuthState,
    required this.signIn,
    required this.register,
    required this.signOut,
  }) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthSignOutRequested>(_onSignOut);

    add(const AuthStarted());
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    await emit.forEach<AppUser?>(
      watchAuthState(),
      onData: (user) => user == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(user),
    );
  }

  Future<void> _onSignIn(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final user = await signIn(event.email, event.password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onRegister(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final user = await register(event.email, event.password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onSignOut(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await signOut();
  }
}


