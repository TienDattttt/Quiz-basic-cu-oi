import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/teacher_repository.dart';

class TeacherResultExamPage extends StatefulWidget {
  final int classId;
  const TeacherResultExamPage({super.key, required this.classId});

  @override
  State<TeacherResultExamPage> createState() => _TeacherResultExamPageState();
}

class _TeacherResultExamPageState extends State<TeacherResultExamPage> {
  List<Map<String, dynamic>> exams = [];
  bool loading = false;

  TeacherRepository get repo => context.read<TeacherRepository>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final res = await repo.api.client.get('/api/teacher/results/class/${widget.classId}/exams');
      exams = (res.data as List).cast<Map<String, dynamic>>();
    } catch (e) {
      EasyLoading.showError('Lỗi tải bài thi: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài thi'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: exams.length,
          itemBuilder: (_, i) {
            final e = exams[i];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(e['title']),
                subtitle: Text('Thời lượng: ${e['durationMinutes']} phút'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(
                    '/teacher/results/exam/${e['id']}/students'),
              ),
            );
          }),
    );
  }
}
