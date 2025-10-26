class Classroom {
  final int id;
  final String className;
  Classroom({required this.id, required this.className});

  factory Classroom.fromJson(Map<String, dynamic> j) =>
      Classroom(id: j['id'] ?? j['classId'], className: j['className']);

  @override
  String toString() => className;
}
