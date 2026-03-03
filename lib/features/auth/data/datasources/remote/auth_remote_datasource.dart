import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/api/api_client.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/auth/data/datasources/auth_datasource.dart';
import 'package:mini_grocery/features/auth/data/models/auth_api_model.dart';

/// Provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

/// Remote Datasource Implementation
class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService;

  // ================= LOGIN =================
  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.data['success'] == true) {
      /// ✅ VERY IMPORTANT
      /// Pass FULL response so token can be read
      final user = AuthApiModel.fromJson(response.data);

      /// Debug (remove later)
      print('LOGIN TOKEN => ${user.token}');

      /// Save session WITH TOKEN
      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        username: user.username,
        phoneNumber: user.phoneNumber,
        profilePicture: user.profilePicture,
        token: user.token,
      );

      return user;
    }

    return null;
  }


  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      return AuthApiModel.fromJson(response.data);
    }

    throw Exception(response.data['message'] ?? 'Registration failed');
  }

  @override
  Future<void> uploadProfileImage(String userId, File image) async {
    final token = _userSessionService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please login again.');
    }

    final formData = FormData.fromMap({
      'profilePicture': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    final response = await _apiClient.put(
      ApiEndpoints.updateProfile,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Image upload failed');
    }
  }


  @override
  Future<AuthApiModel?> getUserById(String authId) async {
    // Not implemented yet
    throw UnimplementedError();
  }
}
