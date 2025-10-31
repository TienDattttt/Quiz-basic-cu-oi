import 'package:dio/dio.dart';
import 'package:mobile/core/storage/secure_storage.dart';

import '../../models/subject.dart';
import '../../models/classroom.dart';
import '../../models/question.dart';
import '../../models/exam_simple.dart';

class TeacherApi {
  final Dio _dio;
  TeacherApi(this._dio);

  Options _authOptions(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// SUBJECTS
  Future<List<Subject>> getSubjects() async {
    final token = await SecureStore.getToken();
    final res = await _dio.get('/api/subjects', options: _authOptions(token!));
    return (res.data as List).map((e) => Subject.fromJson(e)).toList();
  }

  /// CLASSROOMS (nếu chưa có endpoint, dùng fallback mock)
  Future<List<Classroom>> getClassrooms() async {
    final token = await SecureStore.getToken();
    final res = await _dio.get('/api/classrooms', options: _authOptions(token!));
    return (res.data as List).map((e) => Classroom.fromJson(e)).toList();
  }

  /// QUESTIONS
  Future<List<Question>> getQuestionsBySubject(int subjectId) async {
    final token = await SecureStore.getToken();
    final res = await _dio.get(
      '/api/questions',
      queryParameters: {'subjectId': subjectId},
      options: _authOptions(token!),
    );
    return (res.data as List).map((e) => Question.fromJson(e)).toList();
  }

  Future<Question> createQuestion(Question q) async {
    final token = await SecureStore.getToken();
    final res = await _dio.post('/api/questions',
        data: q.toJson(), options: _authOptions(token!));
    return Question.fromJson(res.data);
  }

  Future<Question> updateQuestion(int id, Question q) async {
    final token = await SecureStore.getToken();
    final res = await _dio.put('/api/questions/$id',
        data: q.toJson(), options: _authOptions(token!));
    return Question.fromJson(res.data);
  }

  Future<void> deleteQuestion(int id) async {
    final token = await SecureStore.getToken();
    await _dio.delete('/api/questions/$id', options: _authOptions(token!));
  }

  /// EXAMS
  Future<ExamSimple> createExam({required int subjectId, required String title}) async {
    final token = await SecureStore.getToken();
    final res = await _dio.post('/api/exams',
        data: {'subjectId': subjectId, 'title': title},
        options: _authOptions(token!));
    return ExamSimple.fromJson(res.data);
  }

  Future<List<ExamSimple>> getExamsBySubject(int subjectId) async {
    final token = await SecureStore.getToken();
    final res = await _dio.get('/api/exams',
        queryParameters: {'subjectId': subjectId},
        options: _authOptions(token!));
    return (res.data as List).map((e) => ExamSimple.fromJson(e)).toList();
  }

  /// ASSIGN EXAM
  /// Note: đổi `assignPath` nếu backend của bạn khác (ví dụ: /api/exam-assignments)
  final String assignPath = '/api/exam-assignments';

  Future<void> assignExam({required int examId, required int classId}) async {
    final token = await SecureStore.getToken();
    await _dio.post(assignPath,
        data: {'examId': examId, 'classId': classId},
        options: _authOptions(token!));
  }

  // 🧑‍🎓 Lấy danh sách học viên chưa có lớp
  Future<List<Map<String, dynamic>>> getAvailableStudents() async {
    final token = await SecureStore.getToken();
    final res = await _dio.get(
      '/api/classrooms/students/available',
      options: _authOptions(token!),
    );
    return (res.data as List).cast<Map<String, dynamic>>();
  }

// 🏫 Lấy danh sách học viên trong lớp
  Future<List<Map<String, dynamic>>> getStudentsByClass(int classId) async {
    final token = await SecureStore.getToken();
    final res = await _dio.get(
      '/api/classrooms/$classId/students',
      options: _authOptions(token!),
    );
    return (res.data as List).cast<Map<String, dynamic>>();
  }

// ➕ Gán học viên vào lớp
  Future<void> addStudentsToClass(int classId, List<int> studentIds) async {
    final token = await SecureStore.getToken();
    await _dio.post(
      '/api/classrooms/$classId/students',
      data: {'studentIds': studentIds},
      options: _authOptions(token!),
    );
  }

  // -----------------------------------
// SUBJECT CRUD
// -----------------------------------
  Future<Subject> createSubject(String name) async {
    final token = await SecureStore.getToken();
    final res = await _dio.post(
      '/api/subjects',
      data: {'subjectName': name},
      options: _authOptions(token!),
    );
    return Subject.fromJson(res.data);
  }

  Future<Subject> updateSubject(int id, String name) async {
    final token = await SecureStore.getToken();
    final res = await _dio.put(
      '/api/subjects/$id',
      data: {'subjectName': name},
      options: _authOptions(token!),
    );
    return Subject.fromJson(res.data);
  }

  Future<void> deleteSubject(int id) async {
    final token = await SecureStore.getToken();
    await _dio.delete('/api/subjects/$id', options: _authOptions(token!));
  }


}
