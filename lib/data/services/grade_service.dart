import '../../core/network/dio_client.dart';
import '../models/grade_model.dart';

class GradeService {
  final DioClient _dioClient;

  GradeService(this._dioClient);

  Future<TranscriptModel> getTranscript(int studentId) async {
    try {
      final response = await _dioClient.dio.get('/v1/students/$studentId/transcript');
      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) {
          return TranscriptModel.fromJson(body['data']);
        } else {
          throw Exception(body['message'] ?? 'Failed to load transcript');
        }
      } else {
        throw Exception('Failed to load transcript: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load transcript: $e');
    }
  }
}
