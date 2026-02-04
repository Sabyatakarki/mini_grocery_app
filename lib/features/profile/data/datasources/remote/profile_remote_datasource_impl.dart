import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/api/api_client.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/profile/data/datasources/profile_datasource.dart';
import 'package:mini_grocery/features/profile/data/models/profile_api_model.dart';

final profileRemoteDataSourceProvider =
    Provider<IProfileRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);

  return ProfileRemoteDataSource(
    apiClient: apiClient,
    userSessionService: userSessionService,
  );
});

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  ProfileRemoteDataSource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService;

  /// Update profile with optional image
  @override
  Future<ProfileApiModel> updateProfile(ProfileApiModel profile, {File? imageFile}) async {
    final token = _userSessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("No token found. Please login again.");
    }

    // Prepare form data
    final Map<String, dynamic> formDataMap = {
      'fullName': profile.fullName,
      'email': profile.email,
      'phoneNumber': profile.phoneNumber ?? '',
      'username': profile.username ?? '',
    };

    if (imageFile != null) {
      formDataMap['profilePicture'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(formDataMap);

    // Send request
    final response = await _apiClient.dio.post(
      ApiEndpoints.updateProfile,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token', // <-- Token added here
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    // Check response
    if (response.data != null && response.data['success'] == true) {
      return ProfileApiModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data?['message'] ?? 'Failed to update profile');
    }
  }

  /// Upload profile picture only
  @override
  Future<String> uploadProfilePicture(File imageFile) async {
    final token = _userSessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("No token found. Please login again.");
    }

    final formData = FormData.fromMap({
      'profilePicture': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    final response = await _apiClient.dio.post(
      '${ApiEndpoints.baseUrl}/api/auth/upload-profile-picture',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token', // <-- Token added here
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.data != null && response.data['success'] == true) {
      final url = response.data['data']?['profilePicture'] as String?;
      if (url != null && url.isNotEmpty) return url;
      throw Exception('Server did not return profile picture URL');
    } else {
      throw Exception(response.data?['message'] ?? 'Failed to upload profile picture');
    }
  }
}
