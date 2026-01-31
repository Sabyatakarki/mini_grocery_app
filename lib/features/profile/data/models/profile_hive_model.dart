import 'package:hive/hive.dart';
import 'package:mini_grocery/core/constants/hive_table_constant.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';

part 'profile_hive_model.g.dart';

/// Hive model for profile
@HiveType(typeId: HiveTableConstant.profileTypeId)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String username;

  @HiveField(4)
  final String? phoneNumber;

  @HiveField(5)
  final String? profilePicture;

  ProfileHiveModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.profilePicture,
  });

  /// Convert Hive Model → Domain Entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );
  }

  /// Convert Domain Entity → Hive Model
  factory ProfileHiveModel.fromEntity(ProfileEntity entity) {
    return ProfileHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
    );
  }
}