import 'dart:io';

import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';

class ProfileApiModel {
  final String? userId;
  final String fullName;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? profilePicture;
  final File? profilePictureFile; // For upload

  ProfileApiModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.profilePicture,
    this.profilePictureFile,
  });

  // API response → Model
  factory ProfileApiModel.fromJson(Map<String, dynamic> json) {
    return ProfileApiModel(
      userId: json['_id'] ?? json['userId'],
      fullName: json['fullName'] ?? "${json['firstName']} ${json['lastName']}".trim(),
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
    );
  }

  // Model → API request (Update Profile)
  Map<String, dynamic> toJson() {
    // Split fullName into firstName and lastName
    final nameParts = fullName.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "username": username,
      "phoneNumber": phoneNumber,
    };
  }

  // API Model → Domain Entity
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

  // Entity → API Model
  factory ProfileApiModel.fromEntity(ProfileEntity entity, {File? profilePictureFile}) {
    return ProfileApiModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
      profilePictureFile: profilePictureFile,
    );
  }
}