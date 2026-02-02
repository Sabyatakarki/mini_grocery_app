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

  test('AuthApiModel.fromJson handles null values correctly', () {
    final json = {
      '_id': '123',
      'firstName': null,
      'lastName': null,
      'fullName': null,
      'email': null,
      'username': null,
      'phoneNumber': '9812345678',
      'token': 'token123',
      'profilePicture': 'pic.jpg',
    };

    final model = AuthApiModel.fromJson(json);

    expect(model.id, '123');
    expect(model.fullName, ''); // Should be empty string when all name fields are null
    expect(model.email, ''); // Should be empty string when null
    expect(model.username, ''); // Should be empty string when null
    expect(model.phoneNumber, '9812345678');
    expect(model.token, 'token123');
    expect(model.profilePicture, 'pic.jpg');
  });

  test('AuthApiModel.fromJson handles different ID field names', () {
    // Test with '_id'
    final jsonWithUnderscoreId = {
      '_id': '123',
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john@example.com',
      'username': 'johndoe',
    };
    final model1 = AuthApiModel.fromJson(jsonWithUnderscoreId);
    expect(model1.id, '123');

    // Test with 'id'
    final jsonWithId = {
      'id': '456',
      'firstName': 'Jane',
      'lastName': 'Smith',
      'email': 'jane@example.com',
      'username': 'janesmith',
    };
    final model2 = AuthApiModel.fromJson(jsonWithId);
    expect(model2.id, '456');

    // Test with 'userId'
    final jsonWithUserId = {
      'userId': '789',
      'firstName': 'Bob',
      'lastName': 'Wilson',
      'email': 'bob@example.com',
      'username': 'bobwilson',
    };
    final model3 = AuthApiModel.fromJson(jsonWithUserId);
    expect(model3.id, '789');

    // Test priority: '_id' takes precedence
    final jsonWithMultipleIds = {
      '_id': '111',
      'id': '222',
      'userId': '333',
      'firstName': 'Test',
      'lastName': 'User',
      'email': 'test@example.com',
      'username': 'testuser',
    };
    final model4 = AuthApiModel.fromJson(jsonWithMultipleIds);
    expect(model4.id, '111'); // Should use '_id' first
  });

  test('AuthApiModel.fromJson handles different token field names', () {
    // Test with 'token'
    final jsonWithToken = {
      '_id': '123',
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john@example.com',
      'username': 'johndoe',
      'token': 'jwt_token_123',
    };
    final model1 = AuthApiModel.fromJson(jsonWithToken);
    expect(model1.token, 'jwt_token_123');

    // Test with 'accessToken'
    final jsonWithAccessToken = {
      '_id': '456',
      'firstName': 'Jane',
      'lastName': 'Smith',
      'email': 'jane@example.com',
      'username': 'janesmith',
      'accessToken': 'access_token_456',
    };
    final model2 = AuthApiModel.fromJson(jsonWithAccessToken);
    expect(model2.token, 'access_token_456');

    // Test with 'authToken'
    final jsonWithAuthToken = {
      '_id': '789',
      'firstName': 'Bob',
      'lastName': 'Wilson',
      'email': 'bob@example.com',
      'username': 'bobwilson',
      'authToken': 'auth_token_789',
    };
    final model3 = AuthApiModel.fromJson(jsonWithAuthToken);
    expect(model3.token, 'auth_token_789');

    // Test priority: 'token' takes precedence
    final jsonWithMultipleTokens = {
      '_id': '111',
      'firstName': 'Test',
      'lastName': 'User',
      'email': 'test@example.com',
      'username': 'testuser',
      'token': 'primary_token',
      'accessToken': 'secondary_token',
      'authToken': 'tertiary_token',
    };
    final model4 = AuthApiModel.fromJson(jsonWithMultipleTokens);
    expect(model4.token, 'primary_token'); // Should use 'token' first
  });
}
