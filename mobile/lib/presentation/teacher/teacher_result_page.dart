import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../data/repositories/teacher_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherResultPage extends StatefulWidget {
  const TeacherResultPage({super.key});

  @override
  State<TeacherResultPage> createState() => _TeacherResultPageState();
}

class _TeacherResultPageState extends State<TeacherResultPage> {
  List<Map<String, dynamic>> classes = [];
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
      // final token = await repo.api._dio.options.headers['Authorization'];
      final res = await repo.api.client.get('/api/teacher/results/classes');
      classes = (res.data as List).cast<Map<String, dynamic>>();
    } catch (e) {
      EasyLoading.showError('Lỗi tải lớp: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Kết quả thi'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/teacher/home'),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: classes.length,
          itemBuilder: (_, i) {
            final c = classes[i];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(c['className']),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/teacher/results/${c['classId']}/exams'),
              ),
            );
          }),
    );
  }
}
