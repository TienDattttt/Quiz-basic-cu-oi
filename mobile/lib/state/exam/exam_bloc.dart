import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/student_repository.dart';
import '../exam/exam_event.dart';
import '../exam/exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final StudentRepository repo;
  ExamBloc(this.repo) : super(initialExamState) {
    on<FetchStudentExams>(_onFetch);
  }

  Future<void> _onFetch(FetchStudentExams e, Emitter<ExamState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final items = await repo.getExams();
      emit(ExamState(loading: false, items: items));
    } catch (err) {
      emit(ExamState(loading: false, items: const [], error: err.toString()));
    }
  }
}
