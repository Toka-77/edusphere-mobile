import '../models/curriculum_model.dart';
import '../../core/network/dio_client.dart';

class CurriculumService {
  final DioClient _dioClient;

  CurriculumService(this._dioClient);

  Future<CurriculumModel> getCurriculum(int studentId) async {
    try {
      final resp = await _dioClient.dio.get('/v1/students/$studentId/curriculum');
      if (resp.statusCode == 200) {
        final body = resp.data;
        if (body is Map<String, dynamic> && body['success'] == true) {
          return CurriculumModel.fromJson(body['data']);
        }
      }
      throw Exception('Failed to load curriculum data');
    } catch (e) {
      throw Exception('Failed to load curriculum: $e');
    }
  }
}
