import 'package:equatable/equatable.dart';
import '../../data/models/grade_model.dart';

abstract class GradeState extends Equatable {
  const GradeState();
  
  @override
  List<Object> get props => [];
}

class GradeInitial extends GradeState {}

class GradeLoading extends GradeState {}

class GradeLoaded extends GradeState {
  final TranscriptModel transcript;

  const GradeLoaded(this.transcript);

  @override
  List<Object> get props => [transcript];
}

class GradeError extends GradeState {
  final String message;

  const GradeError(this.message);

  @override
  List<Object> get props => [message];
}
