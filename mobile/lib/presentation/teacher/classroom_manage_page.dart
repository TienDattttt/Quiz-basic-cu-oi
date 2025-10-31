import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/teacher_repository.dart';
import '../../data/models/classroom.dart';

class ClassroomManagePage extends StatefulWidget {
  const ClassroomManagePage({super.key});

  @override
  State<ClassroomManagePage> createState() => _ClassroomManagePageState();
}

class _ClassroomManagePageState extends State<ClassroomManagePage> {
  final selected = <int>{};
  List<Map<String, dynamic>> available = [];
  List<Classroom> classes = [];
  Classroom? classroom;

  TeacherRepository get repo => context.read<TeacherRepository>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    EasyLoading.show(status: 'Đang tải...');
    try {
      available = await repo.getAvailableStudents();
      classes = await repo.getClassrooms();
      if (classes.isNotEmpty) {
        classroom = classes.firstWhere(
              (c) => c.id != null,
          orElse: () => classes[0],
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
    } finally {
      EasyLoading.dismiss();
      setState(() {});
    }
  }

  Future<void> _assign() async {
    if (classroom == null || selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chọn lớp và học viên cần gán')));
      return;
    }

    EasyLoading.show(status: 'Đang gán...');
    try {
      await repo.addStudentsToClass(classroom!.id, selected.toList());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gán học viên thành công!')));
      context.go('/teacher/home');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gán thất bại: $e')));
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = available.isNotEmpty && classes.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gán học viên vào lớp'),
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
            DropdownButtonFormField<Classroom>(
              value: classroom,
              items: classes
                  .map((c) =>
                  DropdownMenuItem(value: c, child: Text(c.className)))
                  .toList(),
              onChanged: (v) => setState(() => classroom = v),
              decoration: const InputDecoration(
                  labelText: 'Chọn lớp',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: available.length,
                itemBuilder: (_, i) {
                  final s = available[i];
                  final id = s['studentId'];
                  return CheckboxListTile(
                    title: Text(s['fullName'] ?? 'No name'),
                    subtitle: Text(s['username'] ?? ''),
                    value: selected.contains(id),
                    onChanged: (v) => setState(() {
                      if (v == true) {
                        selected.add(id);
                      } else {
                        selected.remove(id);
                      }
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _assign,
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6E72FC)),
              child: Text('Gán ${selected.length} học viên'),
            ),
          ],
        ),
      ),
    );
  }
}
