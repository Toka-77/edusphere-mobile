import '../models/dashboard_model.dart';
import '../../core/network/dio_client.dart';

class DashboardService {
  final DioClient _dioClient;

  DashboardService(this._dioClient);

  // ── Public facade ────────────────────────────────────────────────

  /// Fetches all data needed for the dashboard in parallel.
  Future<DashboardData> loadDashboard(int studentId) async {
    final results = await Future.wait([
      _getCgpaData(studentId),
      _getTodaySchedule(),
      _getNotifications(),
      _getEnrolledCount(),
    ]);

    final cgpaMap = results[0] as Map<String, dynamic>?;
    final todayClasses = results[1] as List<TodayClassModel>;
    final notifs = results[2] as List<NotifModel>;
    final enrolledCount = results[3] as int;

    return DashboardData(
      cgpa: (cgpaMap?['cgpa'] as num?)?.toDouble() ?? 0.0,
      totalEnrolledCourses: enrolledCount,
      todayClasses: todayClasses,
      notifications: notifs,
      unreadNotifCount: (cgpaMap != null)
          ? notifs.where((n) => !n.isRead).length
          : notifs.where((n) => !n.isRead).length,
      earnedCredits:
          (cgpaMap?['earned_credits'] as num?)?.toInt() ?? 0,
      requiredCredits:
          (cgpaMap?['total_required_credits'] as num?)?.toInt() ?? 120,
    );
  }

  // ── Private helpers ──────────────────────────────────────────────

  /// GET /v1/students/{id}/cgpa
  /// Response: { "success": true, "data": { "cgpa": 3.8, "earned_credits": 108,
  ///   "total_required_credits": 120, "total_credits": 108, "semesters": [...] } }
  Future<Map<String, dynamic>?> _getCgpaData(int studentId) async {
    try {
      final resp =
          await _dioClient.dio.get('/v1/students/$studentId/cgpa');
      if (resp.statusCode == 200) {
        final body = resp.data;
        if (body is Map && body['success'] == true) {
          return body['data'] as Map<String, dynamic>?;
        }
      }
    } catch (_) {}
    return null;
  }

  /// GET /v1/student/schedule/today
  /// Response: { "success": true, "data": [ { course_code, course_name,
  ///   instructor, room, time, duration, session_type }, ... ] }
  Future<List<TodayClassModel>> _getTodaySchedule() async {
    try {
      final resp =
          await _dioClient.dio.get('/v1/student/schedule/today');
      if (resp.statusCode == 200) {
        final body = resp.data;
        final List raw = body is Map
            ? (body['data'] is List ? body['data'] as List : [])
            : (body is List ? body : []);
        return raw
            .whereType<Map<String, dynamic>>()
            .map(TodayClassModel.fromJson)
            .toList();
      }
    } catch (_) {}
    return [];
  }

  /// GET /v1/notifications
  /// Response: { "success": true, "data": { "notifications": [...],
  ///   "unread_count": 3, "pagination": {...} } }
  /// Each notification: { id, type, title, body, data, read_at, created_at }
  Future<List<NotifModel>> _getNotifications({int limit = 10}) async {
    try {
      final resp = await _dioClient.dio.get('/v1/notifications');
      if (resp.statusCode == 200) {
        final body = resp.data;
        List raw = [];
        if (body is Map && body['data'] is Map) {
          raw = (body['data']['notifications'] as List?) ?? [];
        } else if (body is Map && body['data'] is List) {
          raw = body['data'] as List;
        } else if (body is List) {
          raw = body;
        }
        return raw
            .whereType<Map<String, dynamic>>()
            .take(limit)
            .map(NotifModel.fromJson)
            .toList();
      }
    } catch (_) {}
    return [];
  }

  /// GET /v1/student/schedule  — counts unique enrolled courses across the week.
  Future<int> _getEnrolledCount() async {
    try {
      final resp = await _dioClient.dio.get('/v1/student/schedule');
      if (resp.statusCode == 200) {
        final body = resp.data;
        if (body is Map && body['data'] is Map) {
          final schedule = body['data'] as Map;
          final codes = <String>{};
          for (final day in schedule.values) {
            if (day is List) {
              for (final cls in day) {
                if (cls is Map) {
                  final code = cls['course_code']?.toString();
                  if (code != null && code.isNotEmpty) codes.add(code);
                }
              }
            }
          }
          return codes.length;
        }
      }
    } catch (_) {}
    return 0;
  }
}
