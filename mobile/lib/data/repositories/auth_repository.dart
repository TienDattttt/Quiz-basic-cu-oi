import 'dart:convert';
import '../../core/storage/secure_storage.dart';
import '../datasources/remote/auth_api.dart';
import '../models/auth_models.dart';
import '../../core/utils/error_mapper.dart';

class AuthRepository {
  final AuthApi api;
  AuthRepository(this.api);

  int extractUserIdFromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return 0;
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final data = json.decode(payload);
    return data['uid'] ?? data['userId'] ?? 0;
  }

  Future<AuthResponse> login(String username, String password) async {
    final resp = await api.login(LoginRequest(username: username, password: password));
    print('🔑 TOKEN: ${resp.token}');
    final userId = extractUserIdFromToken(resp.token); // ✅ lấy từ JWT
    await SecureStore.saveToken(resp.token);
    await SecureStore.saveRole(resp.role);
    await SecureStore.saveUserId(userId); // ✅ lưu vào storage
    return AuthResponse(
      token: resp.token,
      username: resp.username,
      role: resp.role,
      userId: userId, // ✅ trả kèm userId
    );
  }

  Future<AuthResponse> register(String username, String password, String fullName, String role) async {
    final resp = await api.register(RegisterRequest(
      username: username,
      password: password,
      fullName: fullName,
      role: role,
    ));
    final userId = extractUserIdFromToken(resp.token); // ✅ tương tự
    print('👤 Extracted userId = $userId');
    await SecureStore.saveToken(resp.token);
    await SecureStore.saveRole(resp.role);
    await SecureStore.saveUserId(userId);
    return AuthResponse(
      token: resp.token,
      username: resp.username,
      role: resp.role,
      userId: userId,
    );
  }

  Future<void> logout() => SecureStore.clear();
}
