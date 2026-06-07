import 'package:equatable/equatable.dart';
import '../../data/models/timetable_model.dart';

abstract class TimetableState extends Equatable {
  const TimetableState();
  @override
  List<Object> get props => [];
}

class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class TimetableLoaded extends TimetableState {
  final List<TimetableModel> events;
  const TimetableLoaded(this.events);
  @override
  List<Object> get props => [events];
}

class TimetableError extends TimetableState {
  final String message;
  const TimetableError(this.message);
  @override
  List<Object> get props => [message];
}
