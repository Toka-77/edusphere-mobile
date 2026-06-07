import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? role;

  // Student-specific fields (null for non-student roles)
  final int? studentNumericId; // student table PK (e.g. 14)
  final String? studentCode;   // e.g. "202600014"
  final int? level;
  final int? creditHours;
  final String? program;
  final bool? isHonor;
  final List<String> phones;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.studentNumericId,
    this.studentCode,
    this.level,
    this.creditHours,
    this.program,
    this.isHonor,
    this.phones = const [],
  });

  /// Two-letter initials derived from the display name.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  /// First word of the name for "Welcome back, {firstName}" style greetings.
  String get firstName {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts[0] : name;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // The profile endpoint nests the student data:
    //   { "data": { "id": 87, ..., "student": { "id": 14, ... } } }
    // The login endpoint inlines student_id / student_code:
    //   { "user": { "id": 87, ..., "student_id": 14, "student_code": 202600014 } }
    final student = json['student'] as Map<String, dynamic>?;

    int? toInt(dynamic v) =>
        v is int ? v : (v != null ? int.tryParse(v.toString()) : null);

    return UserModel(
      id: toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString(),
      studentNumericId: student != null
          ? toInt(student['id'])
          : toInt(json['student_id']),
      studentCode: (student?['code'] ?? json['student_code'])?.toString(),
      level: toInt(student?['level']),
      creditHours: toInt(student?['credit_hours']),
      program: student?['program']?.toString(),
      isHonor: student?['is_honor'] as bool?,
      phones: (student?['phones'] as List?)?.whereType<String>().toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'student_id': studentNumericId,
        'student_code': studentCode,
      };

  @override
  List<Object?> get props =>
      [id, name, email, role, studentNumericId, studentCode];
}
