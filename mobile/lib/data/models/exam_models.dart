class StudentExamItem {
  final int examId;
  final String title;
  final int durationMinutes;

  StudentExamItem({
    required this.examId,
    required this.title,
    required this.durationMinutes,
  });

  factory StudentExamItem.fromJson(Map<String, dynamic> j) => StudentExamItem(
    examId: j['examId'] as int,
    title: j['title'] as String,
    durationMinutes: (j['durationMinutes'] ?? 15) as int,
  );
}
