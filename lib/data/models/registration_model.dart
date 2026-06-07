class AvailableCourse {
  final int teacherCourseId;
  final CourseInfo course;
  final TeacherInfo? teacher;
  final String? schedule;
  final String? sessionType;
  final String? room;
  final String? day;
  final String? section;
  final int capacity;
  final int enrolledCount;
  final bool canRegister;
  final List<String> validationErrors;

  AvailableCourse({
    required this.teacherCourseId,
    required this.course,
    this.teacher,
    this.schedule,
    this.sessionType,
    this.room,
    this.day,
    this.section,
    required this.capacity,
    required this.enrolledCount,
    required this.canRegister,
    required this.validationErrors,
  });

  factory AvailableCourse.fromJson(Map<String, dynamic> json) {
    return AvailableCourse(
      teacherCourseId: json['teacher_course_id'] ?? 0,
      course: CourseInfo.fromJson(json['course'] ?? {}),
      teacher: json['teacher'] != null ? TeacherInfo.fromJson(json['teacher']) : null,
      schedule: json['schedule'],
      sessionType: json['session_type'],
      room: json['room'],
      day: json['day'],
      section: json['section'],
      capacity: json['capacity'] ?? 0,
      enrolledCount: json['enrolled_count'] ?? 0,
      canRegister: json['can_register'] ?? false,
      validationErrors: (json['validation_errors'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class CourseInfo {
  final int id;
  final String code;
  final String title;
  final int creditHours;
  final String? description;
  final int? studentCourseId;

  CourseInfo({
    required this.id,
    required this.code,
    required this.title,
    required this.creditHours,
    this.description,
    this.studentCourseId,
  });

  factory CourseInfo.fromJson(Map<String, dynamic> json) {
    return CourseInfo(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      creditHours: json['credit_hours'] ?? 0,
      description: json['description'],
      studentCourseId: json['student_course_id'],
    );
  }
}

class TeacherInfo {
  final int id;
  final String name;

  TeacherInfo({required this.id, required this.name});

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
