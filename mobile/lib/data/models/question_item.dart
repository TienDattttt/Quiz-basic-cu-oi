class QuestionItem {
  final int id;
  final int subjectId;
  final String content;
  final List<String> options; // [A, B, C, D]
  final String? correctOption; // null khi thi, có khi xem kết quả

  QuestionItem({
    required this.id,
    required this.subjectId,
    required this.content,
    required this.options,
    this.correctOption,
  });

  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    return QuestionItem(
      id: json['id'],
      subjectId: json['subjectId'],
      content: json['content'],
      options: [
        json['optionA'],
        json['optionB'],
        json['optionC'],
        json['optionD'],
      ],
      correctOption: json['correctOption'], // null cũng hợp lệ
    );
  }
}
