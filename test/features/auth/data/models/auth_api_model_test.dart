import 'package:flutter_test/flutter_test.dart';
import 'package:mini_grocery/features/auth/data/models/auth_api_model.dart';

void main() {
  test('AuthApiModel stores data correctly', () {
    final model = AuthApiModel(
      fullName: 'Sabbu',
      email: 'sabbu@gmail.com',
      username: 'sabbu@gmail.com',
      phoneNumber: '9812345678',
      password: 'password123',
    );

    expect(model.fullName, 'Sabbu');
    expect(model.email, 'sabbu@gmail.com');
    expect(model.username, 'sabbu@gmail.com');
    expect(model.phoneNumber, '9812345678');
    expect(model.password, 'password123');
  });
}
