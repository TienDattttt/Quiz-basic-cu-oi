import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _storage = FlutterSecureStorage();
  static const _kToken = 'auth_token';
  static const _kRole  = 'auth_role';
  static const _kUserId = 'auth_user_id'; // ✅

  static Future<void> saveToken(String token) => _storage.write(key: _kToken, value: token);
  static Future<String?> getToken() => _storage.read(key: _kToken);
  static Future<void> deleteToken() => _storage.delete(key: _kToken);

  static Future<void> saveRole(String role) => _storage.write(key: _kRole, value: role);
  static Future<String?> getRole() => _storage.read(key: _kRole);

  static Future<void> saveUserId(int userId) =>
      _storage.write(key: _kUserId, value: userId.toString());
  static Future<int?> getUserId() async {
    final id = await _storage.read(key: _kUserId);
    return id != null ? int.tryParse(id) : null;
  }

  static Future<void> clear() async {
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kRole);
    await _storage.delete(key: _kUserId);
  }
}

