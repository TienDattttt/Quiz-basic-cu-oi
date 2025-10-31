import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/exam_models.dart';
import '../../data/repositories/student_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHistoryDetailPage extends StatefulWidget {
  final int attemptId;
  const StudentHistoryDetailPage({super.key, required this.attemptId});

  @override
  State<StudentHistoryDetailPage> createState() => _StudentHistoryDetailPageState();
}

class _StudentHistoryDetailPageState extends State<StudentHistoryDetailPage> {
  String examTitle = '';
  double score = 0;
  List<ExamHistoryDetail> details = [];
  bool loading = false;

  StudentRepository get repo => context.read<StudentRepository>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final data = await repo.getHistoryDetail(widget.attemptId);
      examTitle = data['examTitle'];
      score = (data['score'] as num).toDouble();
      details = (data['questions'] as List)
          .map((e) => ExamHistoryDetail.fromJson(e))
          .toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải chi tiết: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(examTitle.isEmpty ? 'Chi tiết bài thi' : examTitle),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/student/history'),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: details.length,
        itemBuilder: (_, i) => _question(details[i], i + 1),
      ),
    );
  }

  Widget _question(ExamHistoryDetail q, int idx) {
    List<String> options = ['A', 'B', 'C', 'D'];
    List<String> texts = [q.optionA, q.optionB, q.optionC, q.optionD];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Câu $idx: ${q.content}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (int i = 0; i < 4; i++)
            _option(
              label: options[i],
              text: texts[i],
              isCorrect: q.correctOption == options[i],
              isChosen: q.chosenOption == options[i],
              correct: q.correct,
            ),
        ]),
      ),
    );
  }

  Widget _option({
    required String label,
    required String text,
    required bool isCorrect,
    required bool isChosen,
    required bool correct,
  }) {
    Color bg;
    if (correct && isCorrect) {
      bg = Colors.green.shade100;
    } else if (!correct && isChosen && !isCorrect) {
      bg = Colors.red.shade100;
    } else if (!correct && isCorrect) {
      bg = Colors.green.shade100;
    } else {
      bg = Colors.transparent;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label. $text'),
    );
  }
}
