import 'package:equatable/equatable.dart';
import '../../data/models/curriculum_model.dart';

abstract class CurriculumState extends Equatable {
  const CurriculumState();

  @override
  List<Object?> get props => [];
}

class CurriculumInitial extends CurriculumState {}

class CurriculumLoading extends CurriculumState {}

class CurriculumLoaded extends CurriculumState {
  final CurriculumModel curriculum;

  const CurriculumLoaded(this.curriculum);

  @override
  List<Object?> get props => [curriculum];
}

class CurriculumError extends CurriculumState {
  final String message;

  const CurriculumError(this.message);

  @override
  List<Object?> get props => [message];
}
