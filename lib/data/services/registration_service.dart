import '../../core/network/dio_client.dart';
import '../models/registration_model.dart';

class RegistrationService {
  final DioClient _dioClient;

  RegistrationService(this._dioClient);

  Future<List<AvailableCourse>> getAvailableCourses() async {
    try {
      final response = await _dioClient.dio.get('/v1/student/registration/courses');
      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) {
          final sections = body['data']['sections'] as List?;
          if (sections == null) return [];
          return sections.map((s) => AvailableCourse.fromJson(s)).toList();
        } else {
          throw Exception(body['message'] ?? 'Failed to load courses');
        }
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load courses: $e');
    }
  }

  Future<void> registerForCourse(int teacherCourseId) async {
    try {
      final response = await _dioClient.dio.post(
        '/v1/student/registration/register',
        data: {'teacher_course_id': teacherCourseId},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) {
          return;
        } else {
          throw Exception(body['message'] ?? 'Registration failed');
        }
      } else {
        final body = response.data;
        throw Exception(body['message'] ?? 'Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<List<CourseInfo>> getMyCourses(int studentId) async {
    try {
      final response = await _dioClient.dio.get('/v1/student-courses?student_id=$studentId&status=enrolled&per_page=all');
      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) {
          final courses = body['data'] as List?;
          if (courses == null) return [];
          
          final Map<String, CourseInfo> uniqueCourses = {};
          
          for (final c in courses) {
            final teacherCourse = c['teacher_course'];
            if (teacherCourse != null && teacherCourse['course'] != null) {
              final course = teacherCourse['course'];
              final code = course['code']?.toString() ?? '';
              
              if (code.isNotEmpty && !uniqueCourses.containsKey(code)) {
                uniqueCourses[code] = CourseInfo(
                  id: course['id'] ?? 0,
                  code: code,
                  title: course['title'] ?? '',
                  creditHours: course['credit_hours'] ?? 0,
                  description: teacherCourse['teacher']?['user']?['name']?.toString() ?? '',
                  studentCourseId: c['id'],
                );
              }
            }
          }
          return uniqueCourses.values.toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> dropCourse(int studentCourseId) async {
    try {
      final response = await _dioClient.dio.delete('/v1/student-courses/$studentCourseId');
      if (response.statusCode != 200) {
        final body = response.data;
        throw Exception(body['message'] ?? 'Drop failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to drop course: $e');
    }
  }
}
