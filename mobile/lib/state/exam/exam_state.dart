import '../../data/models/exam_models.dart';

class ExamState {
  final bool loading;
  final List<StudentExamItem> items;
  final String? error;

  const ExamState({this.loading = false, this.items = const [], this.error});

  ExamState copyWith({bool? loading, List<StudentExamItem>? items, String? error}) =>
      ExamState(loading: loading ?? this.loading, items: items ?? this.items, error: error);
}

const ExamState initialExamState = ExamState();
