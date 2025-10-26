import 'package:dio/dio.dart';
import '../../models/auth_models.dart';

class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  Future<AuthResponse> login(LoginRequest req) async {
    final res = await _dio.post('/api/auth/login', data: req.toJson());
    return AuthResponse.fromJson(res.data);
  }

  Future<AuthResponse> register(RegisterRequest req) async {
    final res = await _dio.post('/api/auth/register', data: req.toJson());
    return AuthResponse.fromJson(res.data);
  }
}
