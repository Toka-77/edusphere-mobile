import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/network/dio_client.dart';
import '../models/complaint_model.dart';

class ComplaintService {
  final DioClient _dioClient;

  ComplaintService(this._dioClient);

  static const String _requestType = 'complaint';

  /// Fetch all complaint requests for the authenticated student.
  Future<List<ComplaintModel>> getMyComplaints() async {
    try {
      final response = await _dioClient.dio.get(
        '/v1/student/requests',
        queryParameters: {'request_type': _requestType},
      );
      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) {
          final List raw = body['data'] as List? ?? [];
          return raw
              .whereType<Map<String, dynamic>>()
              .map(ComplaintModel.fromJson)
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Submit a new complaint with optional image attachment.
  Future<void> submitComplaint({
    required String category,
    required String message,
    XFile? attachment,
  }) async {
    try {
      // Combine category + message into the `details` field
      final combinedDetails = 'Category: $category\nMessage: $message';

      FormData formData;

      if (attachment != null) {
        final bytes = await attachment.readAsBytes();
        formData = FormData.fromMap({
          'request_type': _requestType,
          'details': combinedDetails,
          'attachment': MultipartFile.fromBytes(
            bytes,
            filename: attachment.name,
          ),
        });
      } else {
        formData = FormData.fromMap({
          'request_type': _requestType,
          'details': combinedDetails,
        });
      }

      final response = await _dioClient.dio.post(
        '/v1/student/requests',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) return;
        throw Exception(body['message'] ?? 'Submission failed');
      } else {
        final body = response.data;
        throw Exception(body['message'] ?? 'Submission failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          'Network error. Please try again.';
      throw Exception(msg);
    }
  }
}
