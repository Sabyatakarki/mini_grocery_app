import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';
import 'package:mini_grocery/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:mini_grocery/features/profile/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:mini_grocery/features/profile/presentation/state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(
  () => ProfileViewModel(),
);

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdateProfileUseCase _updateProfileUseCase;
  late final UploadProfilePictureUseCase _uploadProfilePictureUseCase;
  late final UserSessionService _userSessionService;

  final ImagePicker _picker = ImagePicker();

  @override
  ProfileState build() {
    _updateProfileUseCase = ref.read(updateProfileUseCaseProvider);
    _uploadProfilePictureUseCase =
        ref.read(uploadProfilePictureUseCaseProvider);
    _userSessionService = ref.read(userSessionServiceProvider);

    final profile = ProfileEntity(
      userId: _userSessionService.getCurrentUserId(),
      fullName: _userSessionService.getCurrentUserFullName() ?? '',
      email: _userSessionService.getCurrentUserEmail() ?? '',
      username: _userSessionService.getCurrentUserUsername() ?? '',
      phoneNumber: _userSessionService.getCurrentUserPhoneNumber(),
      profilePicture: _userSessionService.getCurrentUserProfilePicture(),
    );

    return ProfileState(profile: profile);
  }

  // ─────────────────────────────────────────────
  // IMAGE PICK (NO AUTO UPLOAD)
  // ─────────────────────────────────────────────
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );

      if (pickedFile == null) return;

      final imageFile = File(pickedFile.path);

      // Just store the image locally for preview, don't upload yet
      state = state.copyWith(
        pickedImage: imageFile,
        errorMessage: null,
      );
    } catch (e) {
      debugPrint("Pick image error: $e");
      state = state.copyWith(
        errorMessage: "Failed to pick image",
      );
    }
  }

  Future<String?> _uploadProfilePicture(File imageFile) async {
    final params = UploadProfilePictureParams(imageFile: imageFile);
    final result = await _uploadProfilePictureUseCase(params);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (imageUrl) => imageUrl,
    );
  }

  // ─────────────────────────────────────────────
  // UPDATE PROFILE (TEXT FIELDS)
  // ─────────────────────────────────────────────
  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);

    final updatedProfile = ProfileEntity(
      userId: state.profile!.userId,
      fullName: fullName,
      email: email,
      username: state.profile!.username,
      phoneNumber: phoneNumber,
      profilePicture: state.profile!.profilePicture,
    );

    final params = UpdateProfileParams(profile: updatedProfile);
    final result = await _updateProfileUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profile) async {
        final token = _userSessionService.getToken(); // 🔥 KEEP TOKEN

        // If there's a picked image, upload it now
        String? uploadedImageUrl;
        if (state.pickedImage != null) {
          try {
            state = state.copyWith(isUploadingImage: true);
            uploadedImageUrl = await _uploadProfilePicture(state.pickedImage!);
          } catch (e) {
            debugPrint("Image upload failed: $e");
            // Continue with profile update even if image upload fails
          } finally {
            state = state.copyWith(isUploadingImage: false);
          }
        }

        // Update local session safely
        await _userSessionService.saveUserSession(
          userId: profile.userId!,
          fullName: profile.fullName,
          email: profile.email,
          username: profile.username,
          phoneNumber: profile.phoneNumber,
          profilePicture: uploadedImageUrl ?? profile.profilePicture,
          token: token,
        );

        state = state.copyWith(
          status: ProfileStatus.success,
          profile: profile.copyWith(profilePicture: uploadedImageUrl ?? profile.profilePicture),
          pickedImage: null, // Clear the picked image after successful upload
          errorMessage: null,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
