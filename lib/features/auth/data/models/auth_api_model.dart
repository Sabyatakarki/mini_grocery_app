import 'package:mini_grocery/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? password; // only for request
  final String? token;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.password,
    this.token,
    this.profilePicture,
  });

  /// Convert API JSON → Model
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    // ✅ token comes from top-level JSON
    final token = json['token'] as String?;

    // user info is inside `data`
    final data = json['data'] ?? {};

    final fullName = data['fullName'] ?? '';
    final email = data['email'] ?? '';
    final username = data['username'] ?? '';
    final id = data['_id'] ?? '';
    final phoneNumber = data['phoneNumber'];
    final profilePicture = data['profilePicture'];

    return AuthApiModel(
      id: id,
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      token: token,
      profilePicture: profilePicture,
    );
  }

  /// Model → API request (Signup/Login)
  Map<String, dynamic> toJson({String? confirmPassword}) {
    return {
      "fullName": fullName,
      "email": email,
      "username": username,
      "password": password,
      "confirmPassword": confirmPassword ?? password,
      "phoneNumber": phoneNumber,
    };
  }

  /// Convert Model → Domain Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      password: password,
      token: token,
      profilePicture: profilePicture,
    );
  }

  /// Convert Domain Entity → Model
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      token: entity.token,
      profilePicture: entity.profilePicture,
    );
  }
}
