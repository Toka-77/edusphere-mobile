import '../../core/network/dio_client.dart';

class ChatbotService {
  final DioClient _dioClient;

  ChatbotService(this._dioClient);

  /// POST /v1/advisor/recommend/{studentId}
  /// Body:   { "message": "..." }
  /// Response: { "success": true, "data": { "student_id": int, "recommendation": "..." } }
  Future<String> sendMessage(int studentId, String message) async {
    final resp = await _dioClient.dio.post(
      '/v1/advisor/recommend/$studentId',
      data: {'message': message},
    );

    if (resp.statusCode == 200) {
      final body = resp.data;
      if (body is Map && body['success'] == true) {
        final recommendation =
            (body['data']?['recommendation'] as String?) ?? '';
        if (recommendation.isNotEmpty) return recommendation;
        throw Exception('Empty recommendation returned from AI.');
      }
      throw Exception(body['message'] ?? 'Unknown error from server.');
    }
    throw Exception('Server returned status ${resp.statusCode}.');
  }
}
