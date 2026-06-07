import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add Authorization header if token exists
        final token = await SecureStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // Continue
      },
      onError: (DioException e, handler) {
        // Handle global errors here (e.g., Token Expired 401)
        if (e.response?.statusCode == 401) {
          SecureStorage.deleteToken();
          // You can also emit an event to force user to login screen
        }
        return handler.next(e);
      },
    ));
    
    // Logging only in debug — async print calls crash Flutter Web during transitions
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: false,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ));
    }
  }

  Dio get dio => _dio;
}
