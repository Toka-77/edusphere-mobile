class AttendanceRecord {
  final int id;
  final String status;
  final DateTime recordedAt;
  final String? sessionDate;
  final String? courseCode;
  final String? courseName;
  final String? room;
  final String? instructor;

  const AttendanceRecord({
    required this.id,
    required this.status,
    required this.recordedAt,
    this.sessionDate,
    this.courseCode,
    this.courseName,
    this.room,
    this.instructor,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as int,
      status: (json['status'] as String?) ?? 'present',
      recordedAt: DateTime.tryParse(json['recorded_at']?.toString() ?? '') ??
          DateTime.now(),
      sessionDate: json['session_date']?.toString(),
      courseCode: json['course_code']?.toString(),
      courseName: json['course_name']?.toString(),
      room: json['room']?.toString(),
      instructor: json['instructor']?.toString(),
    );
  }
}

/// Result of a successful QR scan
class AttendanceScanResult {
  final String message;
  final String? courseCode;
  final String? courseName;
  final String? instructor;
  final String? room;
  final String? sessionDate;

  const AttendanceScanResult({
    required this.message,
    this.courseCode,
    this.courseName,
    this.instructor,
    this.room,
    this.sessionDate,
  });

  factory AttendanceScanResult.fromJson(
      Map<String, dynamic> data, String message) {
    // data = the attendance record with nested session.teacherCourse.course
    final session = data['session'] as Map<String, dynamic>?;
    final tc = session?['teacher_course'] as Map<String, dynamic>?;
    final course = tc?['course'] as Map<String, dynamic>?;
    final teacher = tc?['teacher'] as Map<String, dynamic>?;
    final user = teacher?['user'] as Map<String, dynamic>?;

    return AttendanceScanResult(
      message: message,
      courseCode: course?['code']?.toString(),
      courseName: course?['name']?.toString(),
      instructor: user?['name']?.toString(),
      room: tc?['room']?.toString(),
      sessionDate: session?['date']?.toString(),
    );
  }
}
