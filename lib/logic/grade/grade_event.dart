import 'package:equatable/equatable.dart';

abstract class GradeEvent extends Equatable {
  const GradeEvent();

  @override
  List<Object> get props => [];
}

class LoadTranscript extends GradeEvent {
  final int studentId;

  const LoadTranscript(this.studentId);

  @override
  List<Object> get props => [studentId];
}
