class AuthState {
  final bool loading;
  final String? token;
  final String? role;
  final String? error;
  final int? userId;
  final bool? registerSuccess;

  const AuthState({this.loading=false, this.token, this.role, this.error,this.userId,this.registerSuccess});

  AuthState copyWith({bool? loading, String? token, String? role, String? error}) =>
      AuthState(loading: loading ?? this.loading, token: token ?? this.token, role: role ?? this.role, error: error,userId: userId ?? this.userId);
}

const AuthState initialAuthState = AuthState();
