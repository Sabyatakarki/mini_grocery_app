import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/profile/data/datasources/remote/profile_remote_datasource_impl.dart';
import 'package:mini_grocery/features/profile/data/datasources/profile_datasource.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';
import 'package:mini_grocery/features/profile/presentation/state/profile_state.dart';
import 'package:mini_grocery/features/profile/data/models/profile_api_model.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() => ProfileViewModel());

class ProfileViewModel extends Notifier<ProfileState> {
  late final IProfileRemoteDataSource _remoteDataSource;
  late final UserSessionService _userSessionService;
  final ImagePicker _picker = ImagePicker();

  @override
  ProfileState build() {
    _remoteDataSource = ref.read(profileRemoteDataSourceProvider);
    _userSessionService = ref.read(userSessionServiceProvider);

    final profile = ProfileEntity(
      userId: _userSessionService.getCurrentUserId() ?? '',
      fullName: _userSessionService.getCurrentUserFullName() ?? '',
      email: _userSessionService.getCurrentUserEmail() ?? '',
      username: _userSessionService.getCurrentUserUsername() ?? '',
      phoneNumber: _userSessionService.getCurrentUserPhoneNumber(),
      profilePicture: _userSessionService.getCurrentUserProfilePicture(),
    );

    return ProfileState(profile: profile);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 75);
      if (pickedFile == null) return;

      state = state.copyWith(
        pickedImage: File(pickedFile.path),
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: "Failed to pick image");
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);

    final updatedProfile = ProfileApiModel(
      fullName: fullName,
      username: _userSessionService.getCurrentUserUsername() ?? '',
      email: email,
      phoneNumber: phoneNumber,
    );

    try {
      final result = await _remoteDataSource.updateProfile(
        updatedProfile,
        imageFile: state.pickedImage,
      );

      // save to session
      await _userSessionService.saveUserSession(
        userId: _userSessionService.getCurrentUserId() ?? '',
        fullName: result.fullName ?? '',
        email: result.email,
        username: _userSessionService.getCurrentUserUsername() ?? '',
        phoneNumber: result.phoneNumber,
        profilePicture: result.profilePicture,
        token: _userSessionService.getToken() ?? '',
      );

      state = state.copyWith(
        status: ProfileStatus.success,
        profile: state.profile!.copyWith(
          fullName: result.fullName,
          email: result.email,
          phoneNumber: result.phoneNumber,
          profilePicture: result.profilePicture,
        ),
        pickedImage: null,
      );
    } catch (e) {
      state = state.copyWith(status: ProfileStatus.error, errorMessage: e.toString());
    }
  }
}
