import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final File? pickedImage;
  final bool isUploadingImage;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.pickedImage,
    this.isUploadingImage = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    File? pickedImage,
    bool? isUploadingImage,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      pickedImage: pickedImage ?? this.pickedImage,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, pickedImage, isUploadingImage, errorMessage];
}