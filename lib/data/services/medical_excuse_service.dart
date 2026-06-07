import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/network/dio_client.dart';
import '../models/medical_excuse_model.dart';

class MedicalExcuseService {
  final DioClient _dioClient;

  MedicalExcuseService(this._dioClient);

  static const String _requestType = 'leave';

  /// Fetch all medical excuse requests for the authenticated student.
  Future<List<MedicalExcuseModel>> getMyExcuses() async {
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
              .map(MedicalExcuseModel.fromJson)
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Submit a new medical excuse with optional image attachment.
  Future<void> submitExcuse({
    required String description,
    required String details,
    XFile? imageFile,
  }) async {
    try {
      // Combine description + details into the `details` field
      final combinedDetails = 'Description: $description\n\nDetails/Notes: $details';

      FormData formData;

      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        formData = FormData.fromMap({
          'request_type': _requestType,
          'details': combinedDetails,
          'attachment': MultipartFile.fromBytes(
            bytes,
            filename: imageFile.name,
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
