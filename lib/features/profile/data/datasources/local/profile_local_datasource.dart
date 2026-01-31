import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/services/hive/hive_service.dart';
import 'package:mini_grocery/features/profile/data/datasources/profile_datasource.dart';
import 'package:mini_grocery/features/profile/data/models/profile_hive_model.dart';

// Provider
final profileLocalDataSourceProvider = Provider<IProfileLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ProfileLocalDataSource(hiveService: hiveService);
});

class ProfileLocalDataSource implements IProfileLocalDataSource {
  final HiveService _hiveService;

  ProfileLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<ProfileHiveModel?> getProfile(String userId) async {
    // Assuming hiveService has a method to get profile by userId
    // You might need to add this to HiveService
    return await _hiveService.getProfileByUserId(userId);
  }

  @override
  Future<bool> saveProfile(ProfileHiveModel profile) async {
    try {
      // Assuming hiveService has a method to save profile
      await _hiveService.saveProfile(profile);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> updateProfile(ProfileHiveModel profile) async {
    try {
      // Assuming hiveService has a method to update profile
      return await _hiveService.updateProfile(profile);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteProfile(String userId) async {
    try {
      // Assuming hiveService has a method to delete profile
      await _hiveService.deleteProfile(userId);
      return true;
    } catch (_) {
      return false;
    }
  }
}