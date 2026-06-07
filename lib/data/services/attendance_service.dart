import '../../core/network/dio_client.dart';
import '../models/attendance_model.dart';

class AttendanceService {
  final DioClient _dioClient;

  AttendanceService(this._dioClient);

  /// POST /v1/attendance/scan
  /// Submits the scanned QR token and records the student's attendance.
  Future<AttendanceScanResult> scanQR(String token) async {
    final response = await _dioClient.dio.post(
      '/v1/attendance/scan',
      data: {'token': token},
    );

    final body = response.data as Map<String, dynamic>;

    if (body['success'] == true) {
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final message = (body['message'] as String?) ?? 'Attendance recorded.';
      return AttendanceScanResult.fromJson(data, message);
    }

    throw Exception(body['message'] ?? 'Failed to record attendance.');
  }

  /// GET /v1/student/attendance
  /// Returns the authenticated student's attendance history.
  Future<List<AttendanceRecord>> getMyAttendance() async {
    try {
      final response = await _dioClient.dio.get('/v1/student/attendance');
      final body = response.data;
      if (body is Map && body['success'] == true) {
        final list = body['data'] as List? ?? [];
        return list
            .whereType<Map<String, dynamic>>()
            .map(AttendanceRecord.fromJson)
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
