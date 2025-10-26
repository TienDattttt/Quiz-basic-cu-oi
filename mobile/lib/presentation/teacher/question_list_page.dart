import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/subject.dart';
import '../../data/models/question.dart';
import '../../data/repositories/teacher_repository.dart';

class QuestionListPage extends StatefulWidget {
  const QuestionListPage({super.key});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  Subject? selectedSubject;
  List<Subject> subjects = [];
  List<Question> items = [];
  bool loading = false;

  TeacherRepository get repo => context.read<TeacherRepository>();

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() => loading = true);
    try {
      subjects = await repo.getSubjects();
      if (subjects.isNotEmpty) {
        selectedSubject = subjects.first;
        await _loadQuestions();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải môn học: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _loadQuestions() async {
    if (selectedSubject == null) return;
    setState(() => loading = true);
    try {
      items = await repo.getQuestionsBySubject(selectedSubject!.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải câu hỏi: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Xóa câu hỏi?'),
        content: const Text('Thao tác này không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (ok != true) return;

    EasyLoading.show(status: 'Đang xóa...');
    try {
      await repo.deleteQuestion(id);
      items.removeWhere((e) => e.id == id);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Xóa thất bại: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngân hàng câu hỏi'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/teacher/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/teacher/questions/new', extra: selectedSubject),
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<Subject>(
              value: selectedSubject,
              items: subjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.subjectName)))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Môn học', border: OutlineInputBorder(),
              ),

              // ✅ CHỈ GIỮ LẠI onChanged NÀY
              onChanged: (v) async {
                setState(() => selectedSubject = v);
                await _loadQuestions();     // load lại danh sách câu hỏi theo môn
              },

              onSaved: (_) {},    // ✅ vẫn giữ được
              onTap: () {},       // ✅ vẫn giữ được
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, i) => _item(items[i]),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(Question q) {
    return Dismissible(
      key: ValueKey('q_${q.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        await _delete(q.id);
        return false; // mình tự xóa để tránh giật
      },
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.deepPurple.shade50)),
        title: Text(q.content, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('A. ${q.optionA} • B. ${q.optionB} • C. ${q.optionC} • D. ${q.optionD}',
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Color(0xFF6E72FC)),
          onPressed: () => context.go('/teacher/questions/${q.id}', extra: q),
        ),
      ),
    );
  }
}
