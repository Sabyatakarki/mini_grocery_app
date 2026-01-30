import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/api/api_client.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:mini_grocery/features/profile/data/models/profile_api_model.dart';

final profileRemoteDataSourceProvider = Provider<IProfileRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return ProfileRemoteDataSource(apiClient: apiClient, userSessionService: userSessionService);
});

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  ProfileRemoteDataSource({required ApiClient apiClient, required UserSessionService userSessionService})
      : _apiClient = apiClient,
        _userSessionService = userSessionService;

  @override
  Future<ProfileApiModel> updateProfile(ProfileApiModel profile) async {
    final token = _userSessionService.getToken();
    final data = {
      ...profile.toJson(),
      if (token != null) 'token': token,
    };

    final response = await _apiClient.dio.post(
      ApiEndpoints.updateProfile,
      data: data,
    );

    if (response.data['success'] == true) {
      return ProfileApiModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to update profile');
    }
  }

  @override
  Future<String> uploadProfilePicture(File imageFile) async {
    final token = _userSessionService.getToken();
    final formData = FormData.fromMap({
      'profilePicture': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
      if (token != null) 'token': token,
    });

    final response = await _apiClient.uploadFile(
      ApiEndpoints.updateProfile,
      formData: formData,
    );

    if (response.data['success'] == true) {
      return response.data['data']['profilePicture'];
    } else {
      throw Exception(response.data['message'] ?? 'Failed to upload profile picture');
    }
  }
}