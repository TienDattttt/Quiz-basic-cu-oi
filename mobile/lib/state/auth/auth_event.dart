abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String username, password;
  AuthLoginRequested(this.username, this.password);
}

class AuthRegisterRequested extends AuthEvent {
  final String username, password, fullName, role; // role: TEACHER/STUDENT
  AuthRegisterRequested(this.username, this.password, this.fullName, this.role);
}

class AuthCheckStatus extends AuthEvent {}
class AuthLogout extends AuthEvent {}
