import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/teacher_repository.dart';

class TeacherResultStudentsPage extends StatefulWidget {
  final int examId;
  const TeacherResultStudentsPage({super.key, required this.examId});

  @override
  State<TeacherResultStudentsPage> createState() =>
      _TeacherResultStudentsPageState();
}

class _TeacherResultStudentsPageState extends State<TeacherResultStudentsPage> {
  List<Map<String, dynamic>> students = [];
  bool loading = false;

  TeacherRepository get repo => context.read<TeacherRepository>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _formatTime(String time) {
    final dt = DateTime.parse(time).toLocal();
    return DateFormat('HH:mm:ss dd/MM/yyyy').format(dt);
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final res = await repo.api.client.get('/api/teacher/results/exam/${widget.examId}/students');
      students = (res.data as List).cast<Map<String, dynamic>>();
    } catch (e) {
      EasyLoading.showError('Lỗi tải học viên: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả học viên'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: students.length,
          itemBuilder: (_, i) {
            final s = students[i];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(s['studentName']),
                subtitle: Text(
                    'Điểm: ${s['score']} • ${_formatTime(s['submitTime'])}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(
                    '/teacher/results/attempt/${s['attemptId']}'),
              ),
            );
          }),
    );
  }
}
