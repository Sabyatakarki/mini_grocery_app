import 'dart:io';

import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';

class ProfileApiModel {
  final String? userId;
  final String? fullName; 
  final String email;
  final String username;
  final String? phoneNumber;
  final String? profilePicture;
  final File? profilePictureFile;

  ProfileApiModel({
    this.userId,
    this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.profilePicture,
    this.profilePictureFile,
  });


  factory ProfileApiModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'];
    final lastName = json['lastName'];

    String? computedFullName;

    if (json['fullName'] != null) {
      computedFullName = json['fullName'];
    } else if (firstName != null || lastName != null) {
      computedFullName =
          '${firstName ?? ''} ${lastName ?? ''}'.trim();
    } else {
      computedFullName = null;
    }

    return ProfileApiModel(
      userId: json['_id'] ?? json['userId'],
      fullName: computedFullName,
      email: json['email'] ?? '',       
      username: json['username'] ?? '', 
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
    );
  }

  // Model → API request
  Map<String, dynamic> toJson() {
    final nameParts = (fullName ?? '').split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

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
      fullName: fullName ?? '',
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );
  }

  // Entity → API Model
  factory ProfileApiModel.fromEntity(
    ProfileEntity entity, {
    File? profilePictureFile,
  }) {
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
