import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/timetable_service.dart';
import 'timetable_event.dart';
import 'timetable_state.dart';

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  final TimetableService _service;

  TimetableBloc(this._service) : super(TimetableInitial()) {
    on<LoadTimetable>(_onLoad);
  }

  Future<void> _onLoad(LoadTimetable event, Emitter<TimetableState> emit) async {
    emit(TimetableLoading());
    try {
      final events = await _service.getSchedule();
      emit(TimetableLoaded(events));
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }
}
