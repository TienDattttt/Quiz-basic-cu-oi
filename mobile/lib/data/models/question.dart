class Question {
  final int id;
  final int subjectId;
  final String content;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption; // 'A'/'B'/'C'/'D'

  Question({
    required this.id,
    required this.subjectId,
    required this.content,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
  });

  factory Question.fromJson(Map<String, dynamic> j) => Question(
    id: j['id'],
    subjectId: j['subjectId'],
    content: j['content'],
    optionA: j['optionA'],
    optionB: j['optionB'],
    optionC: j['optionC'],
    optionD: j['optionD'],
    correctOption: (j['correctOption'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'content': content,
    'optionA': optionA,
    'optionB': optionB,
    'optionC': optionC,
    'optionD': optionD,
    'correctOption': correctOption,
  };
}
