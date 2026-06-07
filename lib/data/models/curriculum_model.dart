class CurriculumModel {
  final Map<String, CurriculumCourse> courses;
  final List<CurriculumYear> schedule;
  final Map<String, String> statuses;
  final List<String> failedCourses;
  final List<String> droppedCourses;
  final String? program;

  CurriculumModel({
    required this.courses,
    required this.schedule,
    required this.statuses,
    required this.failedCourses,
    required this.droppedCourses,
    this.program,
  });

  factory CurriculumModel.fromJson(Map<String, dynamic> json) {
    return CurriculumModel(
      courses: (json['courses'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, CurriculumCourse.fromJson(value)),
          ) ??
          {},
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((e) => CurriculumYear.fromJson(e))
              .toList() ??
          [],
      statuses: (json['statuses'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value.toString()),
          ) ??
          {},
      failedCourses: List<String>.from(json['failed_courses'] ?? []),
      droppedCourses: List<String>.from(json['dropped_courses'] ?? []),
      program: json['program'] as String?,
    );
  }
}

class CurriculumCourse {
  final String name;
  final int credits;
  final List<String> prereqs;
  final String color;

  CurriculumCourse({
    required this.name,
    required this.credits,
    required this.prereqs,
    required this.color,
  });

  factory CurriculumCourse.fromJson(Map<String, dynamic> json) {
    return CurriculumCourse(
      name: json['name'] ?? '',
      credits: json['credits'] ?? 0,
      prereqs: List<String>.from(json['prereqs'] ?? []),
      color: json['color'] ?? '#000000',
    );
  }
}

class CurriculumYear {
  final int year;
  final String label;
  final List<CurriculumSemester> sems;
  final String? summerLabel;

  CurriculumYear({
    required this.year,
    required this.label,
    required this.sems,
    this.summerLabel,
  });

  factory CurriculumYear.fromJson(Map<String, dynamic> json) {
    return CurriculumYear(
      year: json['year'] ?? 1,
      label: json['label'] ?? '',
      sems: (json['sems'] as List<dynamic>?)
              ?.map((e) => CurriculumSemester.fromJson(e))
              .toList() ??
          [],
      summerLabel: json['summerLabel'] as String?,
    );
  }
}

class CurriculumSemester {
  final String id;
  final String label;
  final List<String> courses;

  CurriculumSemester({
    required this.id,
    required this.label,
    required this.courses,
  });

  factory CurriculumSemester.fromJson(Map<String, dynamic> json) {
    return CurriculumSemester(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      courses: List<String>.from(json['courses'] ?? []),
    );
  }
}
