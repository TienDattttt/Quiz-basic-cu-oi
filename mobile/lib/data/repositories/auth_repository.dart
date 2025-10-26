import '../../core/storage/secure_storage.dart';
import '../datasources/remote/auth_api.dart';
import '../models/auth_models.dart';

class AuthRepository {
  final AuthApi api;
  AuthRepository(this.api);

  Future<AuthResponse> login(String username, String password) async {
    final resp = await api.login(LoginRequest(username: username, password: password));
    await SecureStore.saveToken(resp.token);
    await SecureStore.saveRole(resp.role);
    return resp;
  }

  Future<AuthResponse> register(String username, String password, String fullName, String role) async {
    final resp = await api.register(RegisterRequest(username: username, password: password, fullName: fullName, role: role));
    await SecureStore.saveToken(resp.token);
    await SecureStore.saveRole(resp.role);
    return resp;
  }

  Future<void> logout() => SecureStore.clear();
}
