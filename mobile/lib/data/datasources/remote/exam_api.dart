import 'package:dio/dio.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import '../../models/exam_models.dart';
import '../../models/question_item.dart';
import '../../models/submit_result.dart';

class ExamApi {
  final Dio _dio;
  ExamApi(this._dio);

  Future<List<StudentExamItem>> getStudentExams() async {
    final token = await SecureStore.getToken();
    final res = await _dio.get(
      '/api/student/exams',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (res.data as List).map((e) => StudentExamItem.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getExamDetail(int examId) async {
    final token = await SecureStore.getToken();
    final res = await _dio.get(
      '/api/student/exams/$examId/detail',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

  Future<SubmitResult> submitExam({
    required int examId,
    required Map<int, String> answers,
  }) async {
    final token = await SecureStore.getToken();
    final res = await _dio.post(
      '/api/student/exams/$examId/submit',
      data: {
        "answers": answers.map((k, v) => MapEntry(k.toString(), v)),
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return SubmitResult.fromJson(res.data);
  }

  Future<List<Map<String, dynamic>>> getExamHistory(int studentId) async {
    final token = await SecureStore.getToken();
    final res = await _dio.get(
      '/api/student/history',
      queryParameters: {'studentId': studentId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (res.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getExamHistoryDetail(int attemptId) async {
    final token = await SecureStore.getToken();
    final res = await _dio.get(
      '/api/student/history/$attemptId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data as Map<String, dynamic>;
  }

}
