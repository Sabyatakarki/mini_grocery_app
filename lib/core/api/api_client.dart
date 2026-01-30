import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// ApiClient provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return ApiClient(prefs: prefs);
});

class ApiClient {
  late final Dio _dio;
  final SharedPreferences _prefs;

  ApiClient({required SharedPreferences prefs}) : _prefs = prefs {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    /// Auth interceptor
    _dio.interceptors.add(AuthInterceptor(_prefs));

    /// Retry interceptor
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, _) {
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    /// Logger (debug only)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // ---------------- BASIC REQUESTS ----------------

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get(path,
        queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  // ---------------- FILE UPLOAD ----------------

  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    ProgressCallback? onSendProgress,
  }) {
    return _dio.post(
      path,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
      onSendProgress: onSendProgress,
    );
  }
}

/// ================= AUTH INTERCEPTOR =================

class AuthInterceptor extends Interceptor {
  final SharedPreferences prefs;
  static const _tokenKey = 'auth_token';

  AuthInterceptor(this.prefs);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    final token = prefs.getString(_tokenKey);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
   
    /// Backend bugs / expired routes can cause false 401s

    if (err.response?.statusCode == 401) {
      debugPrint("401 Unauthorized — token kept for safety");
      // logout should be handled explicitly by auth flow
    }

    handler.next(err);
  }
}
