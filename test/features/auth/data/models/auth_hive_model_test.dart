import 'package:flutter_test/flutter_test.dart';
import 'package:mini_grocery/features/auth/data/models/auth_hive_model.dart';
import 'package:mini_grocery/features/auth/domain/entities/auth_entity.dart';

void main() {
  test('AuthHiveModel should convert to AuthEntity correctly', () {
    final hiveModel = AuthHiveModel(
      fullName: 'Sabbu',
      email: 'sabbu@gmail.com',
      phoneNumber: '9812345678',
      username: 'sabbu@gmail.com',
      password: 'password123',
      profilePicture: 'profile.png',
    );

    final entity = hiveModel.toEntity();

    expect(entity.authId, hiveModel.authId);
    expect(entity.fullName, 'Sabbu');
    expect(entity.email, 'sabbu@gmail.com');
    expect(entity.phoneNumber, '9812345678');
    expect(entity.username, 'sabbu@gmail.com');
    expect(entity.password, 'password123');
    expect(entity.profilePicture, 'profile.png');
  });

  test('AuthHiveModel.fromEntity should create HiveModel correctly', () {
    final entity = AuthEntity(
      authId: 'test-id-123',
      fullName: 'Sabbu',
      email: 'sabbu@gmail.com',
      phoneNumber: '9812345678',
      username: 'sabbu@gmail.com',
      password: 'password123',
      profilePicture: 'profile.png',
    );

    final hiveModel = AuthHiveModel.fromEntity(entity);

    expect(hiveModel.authId, 'test-id-123');
    expect(hiveModel.fullName, 'Sabbu');
    expect(hiveModel.email, 'sabbu@gmail.com');
    expect(hiveModel.phoneNumber, '9812345678');
    expect(hiveModel.username, 'sabbu@gmail.com');
    expect(hiveModel.password, 'password123');
    expect(hiveModel.profilePicture, 'profile.png');
  });
}
