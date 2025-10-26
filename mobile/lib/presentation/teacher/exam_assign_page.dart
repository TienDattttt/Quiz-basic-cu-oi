import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/teacher_repository.dart';
import '../../data/models/subject.dart';
import '../../data/models/exam_simple.dart';
import '../../data/models/classroom.dart';

class ExamAssignPage extends StatefulWidget {
  const ExamAssignPage({super.key});

  @override
  State<ExamAssignPage> createState() => _ExamAssignPageState();
}

class _ExamAssignPageState extends State<ExamAssignPage> {
  List<Subject> subjects = [];
  Subject? subject;

  List<ExamSimple> exams = [];
  ExamSimple? exam;

  List<Classroom> classes = [];
  Classroom? classroom;

  TeacherRepository get repo => context.read<TeacherRepository>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    subjects = await repo.getSubjects();
    classes = await repo.getClassrooms();
    subject = subjects.isNotEmpty ? subjects.first : null;
    classroom = classes.isNotEmpty ? classes.first : null;
    if (subject != null) {
      exams = await repo.getExamsBySubject(subject!.id);
    }
    setState(() {});
  }

  Future<void> _onSubjectChange(Subject? s) async {
    setState(() {
      subject = s;
      exams = [];
      exam = null;
    });
    if (s != null) {
      exams = await repo.getExamsBySubject(s.id);
      if (exams.isNotEmpty) exam = exams.first;
      setState(() {});
    }
  }

  Future<void> _assign() async {
    if (exam == null || classroom == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chọn đề thi & lớp')));
      return;
    }
    EasyLoading.show(status: 'Đang gán...');
    try {
      await repo.assignExam(examId: exam!.id, classId: classroom!.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gán đề thi thành công')));
      context.go('/teacher/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gán thất bại: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = subjects.isNotEmpty && classes.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gán đề thi cho lớp'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/teacher/home'),
        ),
      ),
      body: !ready
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Subject>(
              value: subject,
              items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s.subjectName))).toList(),
              onChanged: _onSubjectChange,
              decoration: const InputDecoration(labelText: 'Môn học', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ExamSimple>(
              value: exam,
              items: exams.map((e) => DropdownMenuItem(value: e, child: Text(e.title))).toList(),
              onChanged: (v) => setState(() => exam = v),
              decoration: const InputDecoration(labelText: 'Đề thi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Classroom>(
              value: classroom,
              items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c.className))).toList(),
              onChanged: (v) => setState(() => classroom = v),
              decoration: const InputDecoration(labelText: 'Lớp', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _assign,
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6E72FC)),
              child: const Text('Gán đề'),
            ),
          ],
        ),
      ),
    );
  }
}
