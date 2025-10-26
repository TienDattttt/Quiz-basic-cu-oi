class Subject {
  final int id;
  final String subjectName;
  Subject({required this.id, required this.subjectName});

  factory Subject.fromJson(Map<String, dynamic> j) =>
      Subject(id: j['id'] ?? j['subjectId'], subjectName: j['subjectName']);

  @override
  String toString() => subjectName;
}
