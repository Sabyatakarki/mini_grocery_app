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
  // IMAGE PICK + UPLOAD
  // ─────────────────────────────────────────────
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );

      if (pickedFile == null) return;

      final imageFile = File(pickedFile.path);

      // Show preview immediately
      state = state.copyWith(
        pickedImage: imageFile,
        isUploadingImage: true,
        errorMessage: null,
      );

      await _uploadProfilePicture(imageFile);
    } catch (e) {
      debugPrint("Pick image error: $e");
      state = state.copyWith(
        isUploadingImage: false,
        errorMessage: "Image upload failed",
      );
    }
  }

  Future<void> _uploadProfilePicture(File imageFile) async {
    final params = UploadProfilePictureParams(imageFile: imageFile);
    final result = await _uploadProfilePictureUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          isUploadingImage: false,
          errorMessage: failure.message,
        );
      },
      (imageUrl) async {
        final currentProfile = state.profile!;
        final token = _userSessionService.getToken(); // 🔥 KEEP TOKEN

        // Update local session (DO NOT overwrite token)
        await _userSessionService.saveUserSession(
          userId: currentProfile.userId!,
          fullName: currentProfile.fullName,
          email: currentProfile.email,
          username: currentProfile.username,
          phoneNumber: currentProfile.phoneNumber,
          profilePicture: imageUrl,
          token: token,
        );

        state = state.copyWith(
          profile: currentProfile.copyWith(profilePicture: imageUrl),
          pickedImage: null,
          isUploadingImage: false,
          errorMessage: null,
        );
      },
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

        // Update local session safely
        await _userSessionService.saveUserSession(
          userId: profile.userId!,
          fullName: profile.fullName,
          email: profile.email,
          username: profile.username,
          phoneNumber: profile.phoneNumber,
          profilePicture: profile.profilePicture,
          token: token,
        );

        state = state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          errorMessage: null,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
