import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/curriculum_service.dart';
import 'curriculum_event.dart';
import 'curriculum_state.dart';

class CurriculumBloc extends Bloc<CurriculumEvent, CurriculumState> {
  final CurriculumService _curriculumService;

  CurriculumBloc(this._curriculumService) : super(CurriculumInitial()) {
    on<FetchCurriculum>(_onFetchCurriculum);
  }

  Future<void> _onFetchCurriculum(
    FetchCurriculum event,
    Emitter<CurriculumState> emit,
  ) async {
    emit(CurriculumLoading());
    try {
      final curriculum = await _curriculumService.getCurriculum(event.studentId);
      emit(CurriculumLoaded(curriculum));
    } catch (e) {
      emit(CurriculumError(e.toString()));
    }
  }
}
