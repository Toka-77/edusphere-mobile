import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {
  final int studentId;

  const LoadDashboard(this.studentId);

  @override
  List<Object> get props => [studentId];
}
