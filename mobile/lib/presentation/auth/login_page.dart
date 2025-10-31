import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../state/auth/auth_bloc.dart';
import '../../state/auth/auth_event.dart';
import '../../state/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _u = TextEditingController();
  final _p = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _u.dispose();
    _p.dispose();
    super.dispose();
  }

  void _submit() {
    final u = _u.text.trim();
    final p = _p.text;
    if (u.isEmpty || p.isEmpty) {
      EasyLoading.showError('Nhập đủ username & password');
      return;
    }
    context.read<AuthBloc>().add(AuthLoginRequested(u, p));
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF6E72FC), Color(0xFFAD1DEB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.loading) {
          EasyLoading.show(status: 'Đang đăng nhập...');
        } else {
          EasyLoading.dismiss();
        }

        if (state.error != null) {
          // ✅ Hiển thị lỗi dịch từ ErrorMapper
          EasyLoading.showError(state.error!);
        }

        if (state.token != null && state.role != null) {
          if (state.role!.toUpperCase() == 'TEACHER') {
            context.go('/teacher/home');
          } else {
            context.go('/student/home');
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: gradient),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 16)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Text('Quiz 15 phút',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _u,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Tài khoản'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _p,
                        style: const TextStyle(color: Colors.white),
                        obscureText: _obscure,
                        decoration: _decoration('Mật khẩu').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: state.loading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6E72FC),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Đăng nhập',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text(
                          'Chưa có tài khoản? Đăng ký ngay',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}
