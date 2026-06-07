import 'package:flutter/material.dart';

// ── Today's Class ─────────────────────────────────────────────────

class TodayClassModel {
  final String courseCode;
  final String courseName;
  final String instructor;
  final String room;

  /// Time string in "HH:MM" (24-h) format as returned by the backend.
  final String time;

  /// Duration in minutes (may be null if the backend hasn't set it).
  final int? duration;

  final String sessionType; // "Lecture", "Tutorial", etc.

  const TodayClassModel({
    required this.courseCode,
    required this.courseName,
    required this.instructor,
    required this.room,
    required this.time,
    this.duration,
    required this.sessionType,
  });

  factory TodayClassModel.fromJson(Map<String, dynamic> json) {
    return TodayClassModel(
      courseCode: json['course_code']?.toString() ?? '',
      courseName: json['course_name']?.toString() ?? 'Unknown Course',
      instructor: json['instructor']?.toString() ?? 'Unknown Instructor',
      room: json['room']?.toString() ?? 'TBA',
      time: json['time']?.toString() ?? 'TBA',
      duration: json['duration'] is int ? json['duration'] as int : null,
      sessionType: json['session_type']?.toString() ?? 'Lecture',
    );
  }

  /// 'live' | 'upcoming' | 'done'
  String get status {
    if (time == 'TBA') return 'upcoming';
    try {
      final parts = time.split(':');
      if (parts.length < 2) return 'upcoming';
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final startMin = h * 60 + m;
      final now = TimeOfDay.now();
      final nowMin = now.hour * 60 + now.minute;
      final dur = duration ?? 90;
      if (nowMin >= startMin && nowMin < startMin + dur) return 'live';
      if (nowMin >= startMin + dur) return 'done';
      return 'upcoming';
    } catch (_) {
      return 'upcoming';
    }
  }

  /// Formatted to 12-hour AM/PM string, e.g. "9:00 AM".
  String get formattedTime {
    if (time == 'TBA') return 'TBA';
    try {
      final parts = time.split(':');
      int h = int.parse(parts[0]);
      final m = parts[1];
      final suffix = h >= 12 ? 'PM' : 'AM';
      if (h > 12) h -= 12;
      if (h == 0) h = 12;
      return '$h:$m $suffix';
    } catch (_) {
      return time;
    }
  }
}

// ── Notification ──────────────────────────────────────────────────

class NotifModel {
  final int id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? createdAt;

  const NotifModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    this.createdAt,
  });

  factory NotifModel.fromJson(Map<String, dynamic> json) {
    return NotifModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Notification',
      body: json['body']?.toString() ?? '',
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['read_at'] != null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Human-readable relative time, e.g. "5m ago", "2h ago".
  String get timeAgo {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ── Dashboard Data (aggregate) ────────────────────────────────────

class DashboardData {
  final double cgpa;
  final int totalEnrolledCourses;
  final List<TodayClassModel> todayClasses;
  final List<NotifModel> notifications;
  final int unreadNotifCount;
  final int earnedCredits;
  final int requiredCredits;

  const DashboardData({
    this.cgpa = 0.0,
    this.totalEnrolledCourses = 0,
    this.todayClasses = const [],
    this.notifications = const [],
    this.unreadNotifCount = 0,
    this.earnedCredits = 0,
    this.requiredCredits = 120,
  });
}
