import 'dart:io';

import 'package:mini_grocery/features/profile/data/models/profile_api_model.dart';

abstract class IProfileRemoteDataSource {
  Future<ProfileApiModel> updateProfile(ProfileApiModel profile);
  Future<String> uploadProfilePicture(File imageFile);
}