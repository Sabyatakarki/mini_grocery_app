import 'dart:io';

import 'package:mini_grocery/features/profile/data/models/profile_api_model.dart';
import 'package:mini_grocery/features/profile/data/models/profile_hive_model.dart';

/// Local datasource interface
abstract class IProfileLocalDataSource {
  Future<ProfileHiveModel?> getProfile(String userId);
  Future<bool> saveProfile(ProfileHiveModel profile);
  Future<bool> updateProfile(ProfileHiveModel profile);
  Future<bool> deleteProfile(String userId);
}

/// Remote datasource interface
abstract class IProfileRemoteDataSource {
  Future<ProfileApiModel> updateProfile(ProfileApiModel profile);
  Future<String> uploadProfilePicture(File imageFile);
}