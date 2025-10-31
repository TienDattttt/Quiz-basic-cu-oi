class AuthResponse {
  final String token;
  final String username;
  final String role;
  final int userId;

  AuthResponse({required this.token, required this.username, required this.role, required this.userId,});

  factory AuthResponse.fromJson(Map<String, dynamic> j) =>
      AuthResponse(token: j['token'], username: j['username'], role: j['role'], userId: j['userId'] ?? j['uid'] ?? 0,);
}

class LoginRequest {
  final String username;
  final String password;
  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class RegisterRequest {
  final String username, password, fullName, role;
  RegisterRequest({required this.username, required this.password, required this.fullName, required this.role});
  Map<String, dynamic> toJson() => {
    'username': username, 'password': password, 'fullName': fullName, 'role': role
  };
}
