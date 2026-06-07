import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object?> get props => [];
}

/// Student submits a scanned QR token
class SubmitQRToken extends AttendanceEvent {
  final String token;
  const SubmitQRToken(this.token);
  @override
  List<Object?> get props => [token];
}

/// Load the student's personal attendance history
class LoadAttendanceHistory extends AttendanceEvent {
  const LoadAttendanceHistory();
}

/// Reset the bloc back to idle
class ResetAttendance extends AttendanceEvent {
  const ResetAttendance();
}
