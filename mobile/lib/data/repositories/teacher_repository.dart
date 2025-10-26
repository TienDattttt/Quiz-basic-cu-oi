import '../datasources/remote/teacher_api.dart';
import '../models/subject.dart';
import '../models/classroom.dart';
import '../models/question.dart';
import '../models/exam_simple.dart';

class TeacherRepository {
  final TeacherApi api;
  TeacherRepository(this.api);

  Future<List<Subject>> getSubjects() => api.getSubjects();
  Future<List<Classroom>> getClassrooms() => api.getClassrooms();

  Future<List<Question>> getQuestionsBySubject(int subjectId) =>
      api.getQuestionsBySubject(subjectId);

  Future<Question> createQuestion(Question q) => api.createQuestion(q);
  Future<Question> updateQuestion(int id, Question q) => api.updateQuestion(id, q);
  Future<void> deleteQuestion(int id) => api.deleteQuestion(id);

  Future<ExamSimple> createExam({required int subjectId, required String title}) =>
      api.createExam(subjectId: subjectId, title: title);

  Future<List<ExamSimple>> getExamsBySubject(int subjectId) =>
      api.getExamsBySubject(subjectId);

  Future<void> assignExam({required int examId, required int classId}) =>
      api.assignExam(examId: examId, classId: classId);
}
