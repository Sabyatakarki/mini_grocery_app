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
    // Compute fullName
    final firstName = json['firstName'] as String?;
    final lastName = json['lastName'] as String?;

    String computedFullName;
    if (json['fullName'] != null) {
      computedFullName = json['fullName'];
    } else if (firstName != null || lastName != null) {
      computedFullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    } else {
      computedFullName = '';
    }

    // token might come at top-level or inside data object
    String? token;
    if (json.containsKey('token')) {
      token = json['token'];
    } else if (json['data'] != null && json['data']['token'] != null) {
      token = json['data']['token'];
    }

    // main data object
    final data = json['data'] ?? json;

    return AuthApiModel(
      id: data['_id'] ?? data['id'] ?? data['userId'],
      fullName: computedFullName,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      phoneNumber: data['phoneNumber'],
      token: token,
      profilePicture: data['profilePicture'],
    );
  }

  /// Model → API request
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

  /// Model → Domain Entity
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

  /// Entity → Model
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
