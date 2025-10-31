import '../datasources/remote/exam_api.dart';
import '../models/exam_models.dart';
import '../models/submit_result.dart';

class StudentRepository {
  final ExamApi api;

  StudentRepository(this.api);

  Future<List<StudentExamItem>> getExams() => api.getStudentExams();

  Future<Map<String, dynamic>> getExamDetail(int examId) =>
      api.getExamDetail(examId);

  Future<SubmitResult> submitExam({
    required int examId,
    required Map<int, String> answers,
  }) async {
    return await api.submitExam(
      examId: examId,
      answers: answers,
    );
  }

  Future<List<Map<String, dynamic>>> getHistory(int studentId) =>
      api.getExamHistory(studentId);

  Future<Map<String, dynamic>> getHistoryDetail(int attemptId) =>
      api.getExamHistoryDetail(attemptId);

}
