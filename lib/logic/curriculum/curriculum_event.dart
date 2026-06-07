import 'package:equatable/equatable.dart';

abstract class CurriculumEvent extends Equatable {
  const CurriculumEvent();

  @override
  List<Object?> get props => [];
}

class FetchCurriculum extends CurriculumEvent {
  final int studentId;

  const FetchCurriculum(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
