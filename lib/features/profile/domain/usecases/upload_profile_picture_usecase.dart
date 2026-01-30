import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/error/failures.dart';
import 'package:mini_grocery/core/usecases/app_usecase.dart';
import 'package:mini_grocery/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mini_grocery/features/profile/domain/repositories/profile_repository.dart';

class UploadProfilePictureParams extends Equatable {
  final File imageFile;

  const UploadProfilePictureParams({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}

final uploadProfilePictureUseCaseProvider = Provider<UploadProfilePictureUseCase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return UploadProfilePictureUseCase(profileRepository: profileRepository);
});

class UploadProfilePictureUseCase implements UsecaseWithParams<String, UploadProfilePictureParams> {
  final IProfileRepository _profileRepository;

  UploadProfilePictureUseCase({required IProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, String>> call(UploadProfilePictureParams params) {
    return _profileRepository.uploadProfilePicture(params.imageFile);
  }
}