import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/error/failures.dart';
import 'package:mini_grocery/core/usecases/app_usecase.dart';
import 'package:mini_grocery/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';
import 'package:mini_grocery/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final ProfileEntity profile;

  const UpdateProfileParams({required this.profile});

  @override
  List<Object?> get props => [profile];
}

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return UpdateProfileUseCase(profileRepository: profileRepository);
});

class UpdateProfileUseCase implements UsecaseWithParams<ProfileEntity, UpdateProfileParams> {
  final IProfileRepository _profileRepository;

  UpdateProfileUseCase({required IProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, ProfileEntity>> call(UpdateProfileParams params) {
    return _profileRepository.updateProfile(params.profile);
  }
}