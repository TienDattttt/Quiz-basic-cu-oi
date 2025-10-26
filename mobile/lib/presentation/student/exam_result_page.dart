import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExamResultPage extends StatelessWidget {
  final double score;
  final int total;
  const ExamResultPage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả bài thi'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Điểm của bạn:',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text('$score / $total',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => context.go('/student/home'),
              icon: const Icon(Icons.home),
              label: const Text('Về trang chủ'),
            )
          ],
        ),
      ),
    );
  }
}
