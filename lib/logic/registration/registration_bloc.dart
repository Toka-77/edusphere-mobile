import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/registration_service.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegistrationService _registrationService;

  RegistrationBloc(this._registrationService) : super(RegistrationInitial()) {
    on<LoadAvailableCourses>(_onLoadAvailableCourses);
    on<RegisterCourse>(_onRegisterCourse);
    on<DropCourse>(_onDropCourse);
  }

  Future<void> _onLoadAvailableCourses(LoadAvailableCourses event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      final courses = await _registrationService.getAvailableCourses();
      final myCourses = await _registrationService.getMyCourses(event.studentId);
      emit(RegistrationLoaded(courses, myCourses));
    } catch (e) {
      emit(RegistrationError(e.toString()));
    }
  }

  Future<void> _onRegisterCourse(RegisterCourse event, Emitter<RegistrationState> emit) async {
    if (state is RegistrationLoaded) {
      final currentCourses = (state as RegistrationLoaded).courses;
      final currentMyCourses = (state as RegistrationLoaded).myCourses;
      emit(RegistrationActionInProgress(currentCourses, currentMyCourses, event.teacherCourseId));
      
      try {
        await _registrationService.registerForCourse(event.teacherCourseId);
        // Refresh available courses and my courses after successful registration
        final updatedCourses = await _registrationService.getAvailableCourses();
        final updatedMyCourses = await _registrationService.getMyCourses(event.studentId);
        emit(RegistrationActionSuccess(updatedCourses, updatedMyCourses, 'Course registered successfully.'));
      } catch (e) {
        emit(RegistrationActionFailure(currentCourses, currentMyCourses, e.toString()));
      }
    }
  }

  Future<void> _onDropCourse(DropCourse event, Emitter<RegistrationState> emit) async {
    if (state is RegistrationLoaded) {
      final currentCourses = (state as RegistrationLoaded).courses;
      final currentMyCourses = (state as RegistrationLoaded).myCourses;
      emit(RegistrationActionInProgress(currentCourses, currentMyCourses, event.studentCourseId));
      
      try {
        await _registrationService.dropCourse(event.studentCourseId);
        // Refresh available courses and my courses after successful drop
        final updatedCourses = await _registrationService.getAvailableCourses();
        final updatedMyCourses = await _registrationService.getMyCourses(event.studentId);
        emit(RegistrationActionSuccess(updatedCourses, updatedMyCourses, 'Course dropped successfully.'));
      } catch (e) {
        emit(RegistrationActionFailure(currentCourses, currentMyCourses, e.toString()));
      }
    }
  }
}
