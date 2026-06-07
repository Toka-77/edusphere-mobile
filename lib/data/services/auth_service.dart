import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Assuming the backend returns { "token": "...", "user": {...} }
        final token = data['token'] ?? data['access_token'];
        if (token != null) {
          await SecureStorage.saveToken(token);
        }
        
        final userJson = data['user'] ?? data['data'] ?? data;
        return UserModel.fromJson(userJson);
      } else {
        throw Exception('Failed to login. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        // 401 - wrong credentials
        if (e.response?.statusCode == 401) {
          throw Exception('Invalid email or password. Please try again.');
        }
        // 422 - validation errors
        if (e.response?.statusCode == 422) {
          if (responseData is Map) {
            final errors = responseData['errors'];
            if (errors is Map && errors.isNotEmpty) {
              final firstField = errors.values.first;
              if (firstField is List && firstField.isNotEmpty) {
                final msg = firstField.first.toString();
                // Translate common backend messages
                if (msg.contains('do not match')) {
                  throw Exception('Incorrect email or password. Please try again.');
                }
                throw Exception(msg);
              }
            }
            final message = responseData['message']?.toString();
            if (message != null && message.contains('do not match')) {
              throw Exception('Incorrect email or password. Please try again.');
            }
            if (message != null) throw Exception(message);
          }
        }
        throw Exception('Login failed. Please try again.');
      }
      // Network / timeout errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out. Please check your network.');
      }
      throw Exception('Network error. Please check your connection.');
    }
  }

  Future<void> logout() async {
    try {
      await _dioClient.dio.post(ApiConstants.logout);
    } catch (e) {
      // Even if API call fails, we still want to remove local token
    } finally {
      await SecureStorage.deleteToken();
    }
  }

  Future<UserModel?> getProfile() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) return null;

      final response = await _dioClient.dio.get(ApiConstants.profile);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user'] ?? response.data['data'] ?? response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// PATCH /v1/profile — update display name.
  Future<void> updateProfile(String name) async {
    final resp = await _dioClient.dio.patch(
      ApiConstants.profile,
      data: {'name': name},
    );
    if (resp.statusCode == 200) {
      final body = resp.data;
      if (body is Map && body['success'] == true) return;
      throw Exception(body['message'] ?? 'Profile update failed.');
    }
    throw Exception('Server error ${resp.statusCode}.');
  }

  /// POST /v1/profile/change-password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final resp = await _dioClient.dio.post(
        '${ApiConstants.profile}/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      if (resp.statusCode == 200) {
        final body = resp.data;
        if (body is Map && body['success'] == true) return;
        throw Exception(body['message'] ?? 'Password change failed.');
      }
      throw Exception('Server error ${resp.statusCode}.');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          throw Exception(first is List ? first.first.toString() : first.toString());
        }
        if (data['message'] != null) throw Exception(data['message'].toString());
      }
      rethrow;
    }
  }
}
