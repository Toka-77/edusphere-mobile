import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/grade_service.dart';
import 'grade_event.dart';
import 'grade_state.dart';

class GradeBloc extends Bloc<GradeEvent, GradeState> {
  final GradeService _gradeService;

  GradeBloc(this._gradeService) : super(GradeInitial()) {
    on<LoadTranscript>(_onLoadTranscript);
  }

  Future<void> _onLoadTranscript(LoadTranscript event, Emitter<GradeState> emit) async {
    emit(GradeLoading());
    try {
      final transcript = await _gradeService.getTranscript(event.studentId);
      emit(GradeLoaded(transcript));
    } catch (e) {
      emit(GradeError(e.toString()));
    }
  }
}
