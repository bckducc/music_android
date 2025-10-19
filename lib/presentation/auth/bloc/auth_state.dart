part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AppUser? user;
  final bool loading;
  final String? error;

  const AuthState({this.user, this.loading = false, this.error});

  const AuthState.unknown() : this();
  const AuthState.unauthenticated() : this(user: null);
  const AuthState.authenticated(AppUser user) : this(user: user);

  AuthState copyWith({AppUser? user, bool? loading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  bool get isAuthenticated => user != null;

  @override
  List<Object?> get props => [user, loading, error];
}




