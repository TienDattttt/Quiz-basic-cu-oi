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

  // =================== SUBJECT CRUD ===================

  Future<void> _createSubjectPopup() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Thêm môn học mới'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Tên môn học'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(c, ctrl.text), child: const Text('Lưu')),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;

    EasyLoading.show(status: 'Đang thêm...');
    try {
      final s = await repo.createSubject(name.trim());
      subjects.add(s);
      setState(() {
        selectedSubject = s;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã thêm môn học mới')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Thêm thất bại: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _editSubject(Subject s) async {
    final ctrl = TextEditingController(text: s.subjectName);
    final newName = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Chỉnh sửa môn học'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(c, ctrl.text), child: const Text('Lưu')),
        ],
      ),
    );
    if (newName == null || newName.trim().isEmpty) return;

    EasyLoading.show(status: 'Đang cập nhật...');
    try {
      final updated = await repo.updateSubject(s.id, newName.trim());
      final idx = subjects.indexWhere((x) => x.id == s.id);
      if (idx >= 0) subjects[idx] = updated;

      // ✅ Fix lỗi DropdownButton: gán selectedSubject = updated object
      if (selectedSubject?.id == updated.id) {
        selectedSubject = updated;
      }

      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cập nhật thành công')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi cập nhật: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _deleteSubject(Subject s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Xóa môn học?'),
        content: Text('Bạn có chắc muốn xóa "${s.subjectName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (ok != true) return;

    EasyLoading.show(status: 'Đang xóa...');
    try {
      await repo.deleteSubject(s.id);
      subjects.removeWhere((x) => x.id == s.id);
      if (selectedSubject?.id == s.id) selectedSubject = null;
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã xóa thành công')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Xóa thất bại: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  // =================== LOAD DATA ===================

  Future<void> _loadSubjects() async {
    setState(() => loading = true);
    try {
      subjects = await repo.getSubjects();
      if (subjects.isNotEmpty) {
        selectedSubject = subjects.first;
        await _loadQuestions();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải môn học: $e')));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải câu hỏi: $e')));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Xóa thất bại: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  // =================== UI ===================

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
            onPressed: () =>
                context.go('/teacher/questions/new', extra: selectedSubject),
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Môn học',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Subject>(
                  isExpanded: true,
                  value: selectedSubject,
                  items: [
                    ...subjects.map(
                          (s) => DropdownMenuItem(
                        value: s,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(s.subjectName)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      size: 18, color: Colors.blue),
                                  onPressed: () => _editSubject(s),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      size: 18, color: Colors.red),
                                  onPressed: () => _deleteSubject(s),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const DropdownMenuItem(
                      value: null,
                      child: Text(
                        '+ Thêm môn học mới',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ],
                  onChanged: (v) async {
                    if (v == null) {
                      await _createSubjectPopup();
                    } else {
                      setState(() => selectedSubject = v);
                      await _loadQuestions();
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, i) => _item(items[i]),
              separatorBuilder: (_, __) =>
              const SizedBox(height: 8),
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
        return false; // tránh giật
      },
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.deepPurple.shade50),
        ),
        title: Text(q.content,
            maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          'A. ${q.optionA} • B. ${q.optionB} • C. ${q.optionC} • D. ${q.optionD}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Color(0xFF6E72FC)),
          onPressed: () =>
              context.go('/teacher/questions/${q.id}', extra: q),
        ),
      ),
    );
  }
}
