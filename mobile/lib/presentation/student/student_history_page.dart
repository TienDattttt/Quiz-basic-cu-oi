import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/models/exam_models.dart';
import '../../state/auth/auth_bloc.dart';

class StudentHistoryPage extends StatefulWidget {
  const StudentHistoryPage({super.key});

  @override
  State<StudentHistoryPage> createState() => _StudentHistoryPageState();
}

class _StudentHistoryPageState extends State<StudentHistoryPage> {
  List<ExamHistoryItem> items = [];
  bool loading = false;

  StudentRepository get repo => context.read<StudentRepository>();
  AuthBloc get authBloc => context.read<AuthBloc>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final userId = authBloc.state.userId ?? 0;
      final res = await repo.getHistory(userId);
      items = res.map((e) => ExamHistoryItem.fromJson(e)).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải lịch sử: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  String _formatDate(DateTime dt) {
    final f = DateFormat('HH:mm:ss dd-MM-yyyy');
    return f.format(dt);
  }

  Color _scoreColor(double score) {
    if (score >= 8) return Colors.green.shade600;
    if (score >= 5) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF6E72FC), Color(0xFFAD1DEB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử làm bài'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student/home'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: loading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : items.isEmpty
            ? const Center(
          child: Text(
            'Chưa có bài thi nào được hoàn thành',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, i) => _itemCard(items[i]),
        ),
      ),
    );
  }

  Widget _itemCard(ExamHistoryItem e) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.go('/student/history/${e.attemptId}'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // Icon avatar exam
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF6E72FC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.assignment_turned_in_outlined,
                  color: Color(0xFF6E72FC), size: 30),
            ),
            const SizedBox(width: 14),

            // Nội dung
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.examTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6E72FC).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Color(0xFF6E72FC)),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(e.submitTime.toLocal()),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6E72FC),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            // Điểm
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _scoreColor(e.score).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${e.score.toStringAsFixed(1)}/10',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _scoreColor(e.score),
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
