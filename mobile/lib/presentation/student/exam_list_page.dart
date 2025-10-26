import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../data/models/exam_models.dart';
import '../../state/exam/exam_bloc.dart';
import '../../state/exam/exam_event.dart';
import '../../state/exam/exam_state.dart';
import 'package:go_router/go_router.dart';          // để dùng context.go()
import '../../state/auth/auth_bloc.dart';

class ExamListPage extends StatefulWidget {
  const ExamListPage({super.key});

  @override
  State<ExamListPage> createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExamBloc>().add(FetchStudentExams());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài thi'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ExamBloc, ExamState>(
        listener: (_, s) {
          if (s.loading) EasyLoading.show(); else EasyLoading.dismiss();
          if (s.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi tải danh sách: ${s.error}')),
            );
          }
        },
        builder: (_, s) {
          if (s.items.isEmpty && s.loading == false && s.error == null) {
            return const Center(child: Text('Chưa có bài thi', style: TextStyle(color: Colors.black54)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: s.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _examCard(s.items[i]),
          );
        },
      ),
    );
  }

  Widget _examCard(StudentExamItem e) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.shade50),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.quiz_outlined, color: Color(0xFF6E72FC)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 4),
              Text('10 câu • ${e.durationMinutes} phút', style: TextStyle(color: Colors.grey.shade600)),
            ]),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () {
              context.go('/student/exam/${e.examId}/detail');
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6E72FC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Bắt đầu'),
          )
        ],
      ),
    );
  }
}
