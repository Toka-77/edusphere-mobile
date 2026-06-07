import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class LoadAvailableCourses extends RegistrationEvent {
  final int studentId;

  const LoadAvailableCourses(this.studentId);

  @override
  List<Object> get props => [studentId];
}

class RegisterCourse extends RegistrationEvent {
  final int studentId;
  final int teacherCourseId;

  const RegisterCourse(this.studentId, this.teacherCourseId);

  @override
  List<Object> get props => [studentId, teacherCourseId];
}

class DropCourse extends RegistrationEvent {
  final int studentId;
  final int studentCourseId;

  const DropCourse(this.studentId, this.studentCourseId);

  @override
  List<Object> get props => [studentId, studentCourseId];
}
