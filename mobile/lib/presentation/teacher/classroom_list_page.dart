import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/teacher_repository.dart';
import '../../data/models/classroom.dart';

class ClassroomListPage extends StatefulWidget {
  const ClassroomListPage({super.key});

  @override
  State<ClassroomListPage> createState() => _ClassroomListPageState();
}

class _ClassroomListPageState extends State<ClassroomListPage> {
  List<Classroom> classes = [];
  List<Map<String, dynamic>> students = [];
  Classroom? selectedClass;

  TeacherRepository get repo => context.read<TeacherRepository>();

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    EasyLoading.show(status: 'Đang tải danh sách lớp...');
    try {
      classes = await repo.getClassrooms();
      if (classes.isNotEmpty) {
        selectedClass = classes.first;
        await _loadStudents(selectedClass!.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
    } finally {
      EasyLoading.dismiss();
      setState(() {});
    }
  }

  Future<void> _loadStudents(int classId) async {
    EasyLoading.show(status: 'Đang tải học viên...');
    try {
      students = await repo.getStudentsByClass(classId);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải học viên: $e')));
    } finally {
      EasyLoading.dismiss();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = classes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý lớp học'),
        backgroundColor: const Color(0xFF6E72FC),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Thêm học viên',
            onPressed: () => context.go('/teacher/classrooms/add'),
          ),
        ],
      ),
      body: !ready
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Classroom>(
              value: selectedClass,
              items: classes
                  .map((c) => DropdownMenuItem(
                  value: c, child: Text(c.className)))
                  .toList(),
              onChanged: (v) async {
                setState(() => selectedClass = v);
                if (v != null) await _loadStudents(v.id);
              },
              decoration: const InputDecoration(
                labelText: 'Chọn lớp',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: students.isEmpty
                  ? const Center(child: Text('Chưa có học viên trong lớp'))
                  : ListView.separated(
                itemCount: students.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1),
                itemBuilder: (_, i) {
                  final s = students[i];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(s['fullName'] ?? 'No name'),
                    subtitle: Text(s['username'] ?? ''),
                    trailing: s['enabled'] == true
                        ? const Icon(Icons.check_circle,
                        color: Colors.green)
                        : const Icon(Icons.remove_circle_outline,
                        color: Colors.grey),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
