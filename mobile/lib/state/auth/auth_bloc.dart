import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/storage/secure_storage.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;
  AuthBloc(this.repo) : super(initialAuthState) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthCheckStatus>(_onCheck);
    on<AuthLogout>(_onLogout);
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final resp = await repo.login(e.username, e.password);
      print('📦 AuthBloc emit userId=${resp.userId}');
      emit(AuthState(
        loading: false,
        token: resp.token,
        role: resp.role,
        userId: resp.userId, // ✅ thêm
      ));
    } catch (err) {
      emit(AuthState(loading: false, error: err.toString()));
    }
  }

  Future<void> _onRegister(AuthRegisterRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final resp = await repo.register(e.username, e.password, e.fullName, e.role);
      emit(AuthState(loading: false, token: resp.token, role: resp.role));
    } catch (err) {
      emit(AuthState(loading: false, error: err.toString()));
    }
  }

  Future<void> _onCheck(AuthCheckStatus e, Emitter<AuthState> emit) async {
    final token = await SecureStore.getToken();
    final role = await SecureStore.getRole();
    final userId = await SecureStore.getUserId(); // ✅ đọc lại từ storage
    if (token != null && role != null) {
      emit(AuthState(
        loading: false,
        token: token,
        role: role,
        userId: userId,
      ));
    } else {
      emit(initialAuthState);
    }
  }

  Future<void> _onLogout(AuthLogout e, Emitter<AuthState> emit) async {
    await repo.logout();
    emit(initialAuthState);
  }
}
