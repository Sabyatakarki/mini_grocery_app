import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mini_grocery/core/error/failures.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile);
}