class TimetableModel {
  final String code;
  final String name;
  final String instructor;
  final String room;
  final String time;
  final int day;
  final double startHour;
  final double duration; // in hours
  final String sessionType;

  TimetableModel({
    required this.code,
    required this.name,
    required this.instructor,
    required this.room,
    required this.time,
    required this.day,
    required this.startHour,
    required this.duration,
    required this.sessionType,
  });

  factory TimetableModel.fromJson(Map<String, dynamic> json, int dayIndex) {
    // time format is "HH:mm"
    final timeStr = json['time']?.toString() ?? '00:00';
    double startHour = 0;
    if (timeStr != 'TBA') {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        startHour = int.parse(parts[0]) + (int.parse(parts[1]) / 60);
      }
    }

    // duration comes in minutes
    final durationMins = json['duration'] is int ? json['duration'] as int : 0;
    final durationHrs = durationMins > 0 ? durationMins / 60.0 : 1.5;

    return TimetableModel(
      code: json['course_code'] ?? '',
      name: json['course_name'] ?? '',
      instructor: json['instructor'] ?? '',
      room: json['room'] ?? 'TBA',
      time: timeStr,
      day: dayIndex,
      startHour: startHour,
      duration: durationHrs,
      sessionType: json['session_type'] ?? 'Lecture',
    );
  }
}
