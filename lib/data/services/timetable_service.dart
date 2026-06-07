import '../../core/network/dio_client.dart';
import '../models/timetable_model.dart';

class TimetableService {
  final DioClient _dioClient;

  TimetableService(this._dioClient);

  Future<List<TimetableModel>> getSchedule() async {
    try {
      final response = await _dioClient.dio.get('/v1/student/schedule');
      if (response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['success'] == true) {
          final schedule = body['data'] as Map;
          final List<TimetableModel> events = [];
          
          final dayMap = {
            'Saturday': 0,
            'Sunday': 1,
            'Monday': 2,
            'Tuesday': 3,
            'Wednesday': 4,
            'Thursday': 5,
            'Friday': 6,
          };
          
          for (final entry in schedule.entries) {
            final dayName = entry.key;
            final classes = entry.value;
            
            if (dayMap.containsKey(dayName) && classes is List) {
              final dayIndex = dayMap[dayName]!;
              for (final cls in classes) {
                if (cls is Map<String, dynamic>) {
                  events.add(TimetableModel.fromJson(cls, dayIndex));
                }
              }
            }
          }
          return events;
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load schedule: $e');
    }
  }
}
