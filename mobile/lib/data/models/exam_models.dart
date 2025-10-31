class StudentExamItem {
  final int examId;
  final String title;
  final int durationMinutes;
  final double? score; // ✅ thêm

  StudentExamItem({
    required this.examId,
    required this.title,
    required this.durationMinutes,
    this.score,
  });

  factory StudentExamItem.fromJson(Map<String, dynamic> j) => StudentExamItem(
    examId: j['examId'],
    title: j['title'],
    durationMinutes: j['durationMinutes'],
    score: j['score'] != null ? (j['score'] as num).toDouble() : null, // ✅ đọc thêm score
  );
}

// ===========================
// 2️⃣ Dành cho lịch sử làm bài
// ===========================
class ExamHistoryItem {
  final int attemptId;
  final String examTitle;
  final double score;
  final DateTime submitTime;

  ExamHistoryItem({
    required this.attemptId,
    required this.examTitle,
    required this.score,
    required this.submitTime,
  });

  factory ExamHistoryItem.fromJson(Map<String, dynamic> j) => ExamHistoryItem(
    attemptId: j['attemptId'],
    examTitle: j['examTitle'],
    score: (j['score'] as num).toDouble(),
    submitTime: DateTime.parse(j['submitTime']),
  );
}

// ===========================
// 3️⃣ Dành cho chi tiết lịch sử
// ===========================
class ExamHistoryDetail {
  final String content;
  final String optionA, optionB, optionC, optionD;
  final String? chosenOption;
  final String correctOption;
  final bool correct;

  ExamHistoryDetail({
    required this.content,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    this.chosenOption,
    required this.correct,
  });

  factory ExamHistoryDetail.fromJson(Map<String, dynamic> j) => ExamHistoryDetail(
    content: j['content'],
    optionA: j['optionA'],
    optionB: j['optionB'],
    optionC: j['optionC'],
    optionD: j['optionD'],
    correctOption: j['correctOption'],
    chosenOption: j['chosenOption'],
    correct: j['correct'] ?? false,
  );
}