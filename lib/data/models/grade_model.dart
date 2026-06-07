class CourseGrade {
  final String courseCode;
  final String courseTitle;
  final int creditHours;
  final double totalScore;
  final String letterGrade;
  final double gradePoints;
  final String status;

  CourseGrade({
    required this.courseCode,
    required this.courseTitle,
    required this.creditHours,
    required this.totalScore,
    required this.letterGrade,
    required this.gradePoints,
    required this.status,
  });

  factory CourseGrade.fromJson(Map<String, dynamic> json) {
    return CourseGrade(
      courseCode: json['course_code'] ?? '',
      courseTitle: json['course_title'] ?? '',
      creditHours: json['credit_hours'] is int ? json['credit_hours'] : int.tryParse(json['credit_hours']?.toString() ?? '0') ?? 0,
      totalScore: json['total_score'] != null ? double.tryParse(json['total_score'].toString()) ?? 0.0 : 0.0,
      letterGrade: json['letter_grade'] ?? 'N/A',
      gradePoints: json['grade_points'] != null ? double.tryParse(json['grade_points'].toString()) ?? 0.0 : 0.0,
      status: json['status'] ?? '',
    );
  }
}

class SemesterGrade {
  final int semesterId;
  final String semesterName;
  final String academicYear;
  final double gpa;
  final int totalCredits;
  final List<CourseGrade> courses;

  SemesterGrade({
    required this.semesterId,
    required this.semesterName,
    required this.academicYear,
    required this.gpa,
    required this.totalCredits,
    required this.courses,
  });

  factory SemesterGrade.fromJson(Map<String, dynamic> json) {
    return SemesterGrade(
      semesterId: json['semester_id'] ?? 0,
      semesterName: json['semester_name'] ?? 'Unknown Semester',
      academicYear: json['academic_year'] ?? '',
      gpa: json['gpa'] != null ? double.tryParse(json['gpa'].toString()) ?? 0.0 : 0.0,
      totalCredits: json['total_credits'] ?? 0,
      courses: (json['courses'] as List?)?.map((c) => CourseGrade.fromJson(c)).toList() ?? [],
    );
  }
}

class TranscriptModel {
  final double cgpa;
  final int totalCredits;
  final List<SemesterGrade> semesters;

  TranscriptModel({
    required this.cgpa,
    required this.totalCredits,
    required this.semesters,
  });

  factory TranscriptModel.fromJson(Map<String, dynamic> json) {
    return TranscriptModel(
      cgpa: json['cgpa'] != null ? double.tryParse(json['cgpa'].toString()) ?? 0.0 : 0.0,
      totalCredits: json['total_credits'] ?? 0,
      semesters: (json['semesters'] as List?)?.map((s) => SemesterGrade.fromJson(s)).toList() ?? [],
    );
  }
}
