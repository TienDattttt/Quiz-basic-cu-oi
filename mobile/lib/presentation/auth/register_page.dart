import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../../state/auth/auth_bloc.dart';
import '../../state/auth/auth_event.dart';
import '../../state/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _full = TextEditingController();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;
  String role = 'STUDENT';

  @override
  void dispose() {
    _full.dispose();
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  bool _validatePassword(String p) {
    if (p.length < 8) {
      EasyLoading.showError("Mật khẩu phải có ít nhất 8 ký tự");
      return false;
    }
    if (!RegExp(r'[A-Z]').hasMatch(p)) {
      EasyLoading.showError("Mật khẩu phải chứa ít nhất 1 chữ hoa (A–Z)");
      return false;
    }
    if (!RegExp(r'[a-z]').hasMatch(p)) {
      EasyLoading.showError("Mật khẩu phải chứa ít nhất 1 chữ thường (a–z)");
      return false;
    }
    if (!RegExp(r'[0-9]').hasMatch(p)) {
      EasyLoading.showError("Mật khẩu phải chứa ít nhất 1 chữ số (0–9)");
      return false;
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(p)) {
      EasyLoading.showError("Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt (!@#\$&*~)");
      return false;
    }
    return true;
  }


  void _submit() {
    final f = _full.text.trim();
    final u = _user.text.trim();
    final p = _pass.text.trim();

    if (f.isEmpty || u.isEmpty || p.isEmpty) {
      EasyLoading.showError("Nhập đầy đủ thông tin");
      return;
    }

    if (!_validatePassword(p)) return;

    // OK => Gửi API
    context.read<AuthBloc>().add(AuthRegisterRequested(u, p, f, role));
  }


  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF6E72FC), Color(0xFFAD1DEB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.loading) EasyLoading.show(); else EasyLoading.dismiss();

        if (state.error != null) {
          EasyLoading.showError("Đăng ký thất bại");
        }

        if (state.registerSuccess == true) {
          EasyLoading.showSuccess("Đăng ký thành công");
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) context.go('/login');
        }
      },
      builder: (_, state) {
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
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Đăng ký tài khoản",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 24),

                      _input("Họ tên", _full),
                      const SizedBox(height: 12),
                      _input("Tài khoản", _user),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _pass,
                        style: const TextStyle(color: Colors.white),
                        obscureText: _obscure,
                        decoration: _decoration("Mật khẩu").copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: role,
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: Colors.black54,
                        decoration: _decoration("Vai trò"),
                        items: const [
                          DropdownMenuItem(value: "STUDENT", child: Text("Student")),
                          DropdownMenuItem(value: "TEACHER", child: Text("Teacher")),
                        ],
                        onChanged: (v) => setState(() => role = v!),
                      ),

                      const SizedBox(height: 20),

                      FilledButton(
                        onPressed: state.loading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6E72FC),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Đăng ký"),
                      ),

                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text("Đã có tài khoản? Đăng nhập",
                            style: TextStyle(color: Colors.white)),
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

  TextField _input(String label, TextEditingController c) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      decoration: _decoration(label),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
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
