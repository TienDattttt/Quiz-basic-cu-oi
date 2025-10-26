import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/subject.dart';
import '../../data/models/question.dart';
import '../../data/repositories/teacher_repository.dart';

class QuestionFormPage extends StatefulWidget {
  final Question? editing; // null = create
  final Subject? preSelectedSubject;
  const QuestionFormPage({super.key, this.editing, this.preSelectedSubject});

  @override
  State<QuestionFormPage> createState() => _QuestionFormPageState();
}

class _QuestionFormPageState extends State<QuestionFormPage> {
  final form = GlobalKey<FormState>();
  List<Subject> subjects = [];
  Subject? subject;

  final contentCtrl = TextEditingController();
  final aCtrl = TextEditingController();
  final bCtrl = TextEditingController();
  final cCtrl = TextEditingController();
  final dCtrl = TextEditingController();
  String correct = 'A';

  TeacherRepository get repo => context.read<TeacherRepository>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    subjects = await repo.getSubjects();
    if (widget.editing != null) {
      final q = widget.editing!;
      subject = subjects.firstWhere((s) => s.id == q.subjectId, orElse: () => subjects.first);
      contentCtrl.text = q.content;
      aCtrl.text = q.optionA;
      bCtrl.text = q.optionB;
      cCtrl.text = q.optionC;
      dCtrl.text = q.optionD;
      correct = q.correctOption.isEmpty ? 'A' : q.correctOption;
    } else {
      subject = widget.preSelectedSubject ?? (subjects.isNotEmpty ? subjects.first : null);
    }
    setState(() {});
  }

  Future<void> _save() async {
    if (!form.currentState!.validate()) return;
    if (subject == null) return;

    EasyLoading.show(status: 'Đang lưu...');
    try {
      final q = Question(
        id: widget.editing?.id ?? 0,
        subjectId: subject!.id,
        content: contentCtrl.text.trim(),
        optionA: aCtrl.text.trim(),
        optionB: bCtrl.text.trim(),
        optionC: cCtrl.text.trim(),
        optionD: dCtrl.text.trim(),
        correctOption: correct,
      );

      if (widget.editing == null) {
        await repo.createQuestion(q);
      } else {
        await repo.updateQuestion(widget.editing!.id, q);
      }
      if (!mounted) return;
      context.go('/teacher/questions');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lưu thất bại: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Sửa câu hỏi' : 'Thêm câu hỏi'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/teacher/questions'),
        ),
      ),
      body: subjects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: form,
          child: Column(
            children: [
              DropdownButtonFormField<Subject>(
                value: subject,
                items: subjects
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.subjectName)))
                    .toList(),
                onChanged: (v) => setState(() => subject = v),
                decoration: const InputDecoration(labelText: 'Môn học', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: contentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Nội dung câu hỏi', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập nội dung' : null,
              ),
              const SizedBox(height: 12),
              _opt(aCtrl, 'Đáp án A'),
              const SizedBox(height: 12),
              _opt(bCtrl, 'Đáp án B'),
              const SizedBox(height: 12),
              _opt(cCtrl, 'Đáp án C'),
              const SizedBox(height: 12),
              _opt(dCtrl, 'Đáp án D'),
              const SizedBox(height: 12),
              _correctPicker(),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6E72FC)),
                child: Text(isEdit ? 'Cập nhật' : 'Tạo mới'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _opt(TextEditingController ctrl, String label) => TextFormField(
    controller: ctrl,
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập $label' : null,
  );

  Widget _correctPicker() {
    return Row(
      children: [
        const Text('Đáp án đúng:  '),
        for (final x in ['A', 'B', 'C', 'D'])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(value: x, groupValue: correct, onChanged: (v) => setState(() => correct = v!)),
              Text(x),
            ],
          )
      ],
    );
  }
}
