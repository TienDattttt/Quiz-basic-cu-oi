import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/state/auth/auth_bloc.dart';
import 'package:mobile/state/auth/auth_event.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF6E72FC), Color(0xFFAD1DEB)],
      begin: Alignment.topLeft, end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Học viên'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc muốn đăng xuất?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Đăng xuất')),
                  ],
                ),
              );
              if (confirm == true) {
                context.read<AuthBloc>().add(AuthLogout());
                context.go('/login');
              }
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _cardBig(
                title: '📌 Bài thi đang chờ',
                subtitle: 'Nhấn để xem danh sách bài thi',
                onTap: () => context.go('/student/exams'),
              ),
              const SizedBox(height: 12),
              _cardBig(
                title: '🕘 Lịch sử làm bài',
                subtitle: 'Xem điểm và các lần làm bài trước',
                onTap: () => context.go('/student/history'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardBig({required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ]),
      ),
    );
  }
}
