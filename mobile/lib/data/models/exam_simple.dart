class ExamSimple {
  final int id;
  final int subjectId;
  final String title;
  final int durationMinutes;

  ExamSimple({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.durationMinutes,
  });

  factory ExamSimple.fromJson(Map<String, dynamic> j) => ExamSimple(
    id: j['id'] ?? j['examId'],
    subjectId: j['subjectId'] ?? 0,
    title: j['title'],
    durationMinutes: j['durationMinutes'] ?? 15,
  );

  @override
  String toString() => title;
}
