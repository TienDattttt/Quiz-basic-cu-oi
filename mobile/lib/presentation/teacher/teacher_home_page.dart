import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state/auth/auth_bloc.dart';
import '../../state/auth/auth_event.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF6E72FC), Color(0xFFAD1DEB)],
      begin: Alignment.topLeft, end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giảng viên'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // ✅ bỏ nút back
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogout()); // ✅ clear token
              context.go('/login'); // ✅ quay về login
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            _card(context, '📚 Ngân hàng câu hỏi', '/teacher/questions'),
            const SizedBox(height: 12),
            _card(context, '🧾 Tạo đề thi random (10 câu)', '/teacher/exams/new'),
            const SizedBox(height: 12),
            _card(context, '🎯 Gán đề thi cho lớp', '/teacher/exams/assign'),
          ]),
        ),
      ),
    );
  }

  Widget _card(BuildContext ctx, String title, String route) {
    return InkWell(
      onTap: () => GoRouter.of(ctx).go(route),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
