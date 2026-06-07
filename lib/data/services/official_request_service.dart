import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/official_request_model.dart';

class OfficialRequestService {
  final DioClient _dioClient;

  OfficialRequestService(this._dioClient);

  /// Fetch official requests for the authenticated student.
  /// We fetch all requests and filter out 'leave' and 'complaint' 
  /// so we only show document requests (transcript, certificate, other).
  Future<List<OfficialRequestModel>> getMyOfficialRequests() async {
    try {
      final response = await _dioClient.dio.get('/v1/student/requests');
      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) {
          final List raw = body['data'] as List? ?? [];
          return raw
              .whereType<Map<String, dynamic>>()
              .map(OfficialRequestModel.fromJson)
              .where((req) => 
                req.requestType != 'leave' && 
                req.requestType != 'complaint' &&
                req.requestType != 'medical_excuse')
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Submit a new official document request.
  Future<void> submitRequest({
    required String documentTitle,
  }) async {
    try {
      // Map the document title to the backend ENUM
      String type = 'other';
      if (documentTitle.toLowerCase().contains('transcript')) {
        type = 'transcript';
      } else if (documentTitle.toLowerCase().contains('certificate') || 
                 documentTitle.toLowerCase().contains('statement')) {
        type = 'certificate';
      }

      final combinedDetails = 'Document: $documentTitle';

      final formData = FormData.fromMap({
        'request_type': type,
        'details': combinedDetails,
      });

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
