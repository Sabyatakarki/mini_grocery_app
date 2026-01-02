import 'package:hive/hive.dart';
import 'package:mini_grocery/core/constants/hive_table_constant.dart';
import 'package:mini_grocery/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

/// Hive model for authentication/user
@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String authId;

  @HiveField(1)
  final String? fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? username;

  @HiveField(5)
  final String? password;

  @HiveField(6)
  final String? profilePicture;

  @HiveField(7)
  final String? batchId;

  AuthHiveModel({
    String? authId,
    this.fullName,
    required this.email,
    this.phoneNumber,
    this.username,
    this.password,
    this.profilePicture,
    this.batchId,
  }) : authId = authId ?? const Uuid().v4();

  /// Convert Hive Model to Domain Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      email: email,
      password: password,
      fullName: fullName,
      username: username,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      batchId: batchId,
    );
  }

  /// Create Hive Model from Domain Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      username: entity.username,
      password: entity.password,
      profilePicture: entity.profilePicture,
      batchId: entity.batchId,
    );
  }
}
