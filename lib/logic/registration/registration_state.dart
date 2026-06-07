import 'package:equatable/equatable.dart';
import '../../data/models/registration_model.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
  
  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLoaded extends RegistrationState {
  final List<AvailableCourse> courses;
  final List<CourseInfo> myCourses;

  const RegistrationLoaded(this.courses, this.myCourses);

  @override
  List<Object> get props => [courses, myCourses];
}

class RegistrationError extends RegistrationState {
  final String message;

  const RegistrationError(this.message);

  @override
  List<Object> get props => [message];
}

class RegistrationActionInProgress extends RegistrationLoaded {
  final int registeringCourseId;

  const RegistrationActionInProgress(List<AvailableCourse> courses, List<CourseInfo> myCourses, this.registeringCourseId) : super(courses, myCourses);

  @override
  List<Object> get props => [courses, myCourses, registeringCourseId];
}

class RegistrationActionSuccess extends RegistrationLoaded {
  final String message;

  const RegistrationActionSuccess(List<AvailableCourse> courses, List<CourseInfo> myCourses, this.message) : super(courses, myCourses);

  @override
  List<Object> get props => [courses, myCourses, message];
}

class RegistrationActionFailure extends RegistrationLoaded {
  final String message;

  const RegistrationActionFailure(List<AvailableCourse> courses, List<CourseInfo> myCourses, this.message) : super(courses, myCourses);

  @override
  List<Object> get props => [courses, myCourses, message];
}
