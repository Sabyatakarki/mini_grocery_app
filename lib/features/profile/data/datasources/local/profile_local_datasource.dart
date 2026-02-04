import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/services/hive/hive_service.dart';
import 'package:mini_grocery/features/profile/data/datasources/profile_datasource.dart';
import 'package:mini_grocery/features/profile/data/models/profile_hive_model.dart';

/// Provider for local profile datasource
final profileLocalDataSourceProvider = Provider<IProfileLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ProfileLocalDataSource(hiveService: hiveService);
});

class ProfileLocalDataSource implements IProfileLocalDataSource {
  final HiveService _hiveService;

  ProfileLocalDataSource({required HiveService hiveService})
      : _hiveService = hiveService;

  /// Get profile by userId
  @override
  Future<ProfileHiveModel?> getProfile(String userId) async {
    return await _hiveService.getProfileByUserId(userId);
  }

  /// Save new profile
  @override
  Future<bool> saveProfile(ProfileHiveModel profile) async {
    try {
      await _hiveService.saveProfile(profile);
      return true;
    } catch (e) {
      // You can log e if needed
      return false;
    }
  }

  /// Update existing profile
  @override
  Future<bool> updateProfile(ProfileHiveModel profile) async {
    try {
      return await _hiveService.updateProfile(profile);
    } catch (e) {
      return false;
    }
  }

  /// Delete profile by userId
  @override
  Future<bool> deleteProfile(String userId) async {
    try {
      await _hiveService.deleteProfile(userId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
