import 'package:flutter_bloc/flutter_bloc.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';
import '../../data/services/attendance_service.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceService attendanceService;

  AttendanceBloc({required this.attendanceService}) : super(const AttendanceIdle()) {
    on<SubmitQRToken>(_onSubmitQRToken);
    on<LoadAttendanceHistory>(_onLoadHistory);
    on<ResetAttendance>(_onReset);
  }

  Future<void> _onSubmitQRToken(
      SubmitQRToken event, Emitter<AttendanceState> emit) async {
    emit(const AttendanceSubmitting());
    try {
      final result = await attendanceService.scanQR(event.token);
      emit(AttendanceSuccess(result));
    } catch (e) {
      // Parse friendly error messages from DioException responses
      String msg = e.toString();
      if (msg.contains('Exception: ')) {
        msg = msg.replaceFirst('Exception: ', '');
      }
      emit(AttendanceError(msg));
    }
  }

  Future<void> _onLoadHistory(
      LoadAttendanceHistory event, Emitter<AttendanceState> emit) async {
    emit(const AttendanceHistoryLoading());
    try {
      final records = await attendanceService.getMyAttendance();
      emit(AttendanceHistoryLoaded(records));
    } catch (e) {
      emit(AttendanceHistoryLoaded(const [])); // graceful — show empty list
    }
  }

  void _onReset(ResetAttendance event, Emitter<AttendanceState> emit) {
    emit(const AttendanceIdle());
  }
}
