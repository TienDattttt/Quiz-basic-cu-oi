import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/student_repository.dart';
import 'package:mobile/data/datasources/remote/exam_api.dart';

class ExamDetailPage extends StatefulWidget {
  final int examId;
  const ExamDetailPage({super.key, required this.examId});


  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  late final repo = StudentRepository(
    ExamApi(Dio(BaseOptions(baseUrl: "http://10.0.2.2:8080"))),
  );

  Map<int, String> answers = {};
  Map<String, dynamic>? exam;
  int secondsLeft = 15 * 60;
  Timer? timer;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    _loadExam();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft <= 0) {
        _submitExam();
        t.cancel();
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  Future<void> _loadExam() async {
    final data = await repo.getExamDetail(widget.examId);
    setState(() => exam = data);
    _startTimer();
  }

  Future<void> _submitExam() async {
    if (submitting) return;
    submitting = true;

    final res = await repo.submitExam(
      examId: widget.examId,
      answers: answers,
    );

    if (!mounted) return;
    timer?.cancel();

    context.go('/student/exam/${widget.examId}/result',
        extra: {'score': res.score, 'total': res.total});
  }

  String get timeString {
    final m = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (exam == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final questions = List<Map<String, dynamic>>.from(exam!['questions']);

    return Scaffold(
      appBar: AppBar(
        title: Text('${exam!['title']}  ⏱ $timeString'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          final selected = answers[q['id']];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Câu ${index + 1}: ${q['content']}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  for (var opt in ['A', 'B', 'C', 'D'])
                    RadioListTile<String>(
                      title: Text(q['option$opt']),
                      value: opt,
                      groupValue: selected,
                      onChanged: (v) => setState(() => answers[q['id']] = v!),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitExam,
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.send),
        label: const Text('NỘP BÀI'),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
