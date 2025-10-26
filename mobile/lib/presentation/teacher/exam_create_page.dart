import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/teacher_repository.dart';
import '../../data/models/subject.dart';

class ExamCreatePage extends StatefulWidget {
  const ExamCreatePage({super.key});

  @override
  State<ExamCreatePage> createState() => _ExamCreatePageState();
}

class _ExamCreatePageState extends State<ExamCreatePage> {
  List<Subject> subjects = [];
  Subject? subject;
  final titleCtrl = TextEditingController();

  TeacherRepository get repo => context.read<TeacherRepository>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    subjects = await repo.getSubjects();
    subject = subjects.isNotEmpty ? subjects.first : null;
    setState(() {});
  }

  Future<void> _createExam() async {
    if (subject == null || titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chọn môn & nhập tiêu đề')));
      return;
    }
    EasyLoading.show(status: 'Đang tạo...');
    try {
      await repo.createExam(subjectId: subject!.id, title: titleCtrl.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tạo đề thi thành công')));
      context.go('/teacher/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tạo thất bại: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo đề thi (random 10 câu)'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/teacher/home'),
        ),
      ),
      body: subjects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Subject>(
              value: subject,
              items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s.subjectName))).toList(),
              onChanged: (v) => setState(() => subject = v),
              decoration: const InputDecoration(labelText: 'Môn học', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Tiêu đề đề thi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            const ListTile(
              title: Text('Số câu: 10 (cố định)'),
              subtitle: Text('Hệ thống tự random 10 câu từ ngân hàng'),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _createExam,
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6E72FC)),
              child: const Text('Tạo đề thi'),
            ),
          ],
        ),
      ),
    );
  }
}
