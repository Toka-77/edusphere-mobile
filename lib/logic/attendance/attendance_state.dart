import 'package:equatable/equatable.dart';
import '../../data/models/attendance_model.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object?> get props => [];
}

/// Idle — nothing happening
class AttendanceIdle extends AttendanceState {
  const AttendanceIdle();
}

/// Submitting QR token to backend
class AttendanceSubmitting extends AttendanceState {
  const AttendanceSubmitting();
}

/// QR scan succeeded — attendance recorded
class AttendanceSuccess extends AttendanceState {
  final AttendanceScanResult result;
  const AttendanceSuccess(this.result);
  @override
  List<Object?> get props => [result];
}

/// An error occurred during submission
class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);
  @override
  List<Object?> get props => [message];
}

/// Loading attendance history
class AttendanceHistoryLoading extends AttendanceState {
  const AttendanceHistoryLoading();
}

/// History loaded successfully
class AttendanceHistoryLoaded extends AttendanceState {
  final List<AttendanceRecord> records;
  const AttendanceHistoryLoaded(this.records);
  @override
  List<Object?> get props => [records];
}
