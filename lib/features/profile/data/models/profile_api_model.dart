import 'dart:io';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';

class ProfileApiModel {
  final String? userId;
  final String? fullName;
  final String email;
  final String username;
  final String? phoneNumber;

  /// This will hold the image path/url returned by backend.
  /// Your backend returns it as `imageUrl`, not `profilePicture`.
  final String? profilePicture;

  final File? profilePictureFile; // used when uploading new image

  ProfileApiModel({
    this.userId,
    this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.profilePicture,
    this.profilePictureFile,
  });

  // ───────────── FROM JSON ─────────────
  factory ProfileApiModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'];
    final lastName = json['lastName'];

    String? computedFullName;

    if (json['fullName'] != null) {
      computedFullName = json['fullName']?.toString();
    } else if (firstName != null || lastName != null) {
      computedFullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    } else {
      computedFullName = null;
    }

    return ProfileApiModel(
      userId: (json['_id'] ?? json['userId'])?.toString(),
      fullName: computedFullName,
      email: (json['email'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      phoneNumber: json['phoneNumber']?.toString(),

      // ✅ IMPORTANT FIX:
      // Backend returns: "imageUrl": "/public/profile_pictures/xxx.jpg"
      // Some backends may return "profilePicture". Support both.
      profilePicture: (json['profilePicture'] ?? json['imageUrl'])?.toString(),
    );
  }

  // ───────────── TO JSON ─────────────
  Map<String, dynamic> toJson({bool includeImageFile = false}) {
    final nameParts = (fullName ?? '').trim().split(RegExp(r'\s+'));
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final data = <String, dynamic>{
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "username": username,
      "phoneNumber": phoneNumber ?? '',
    };

    // Note: For multipart upload you are already attaching the file in RemoteDataSource
    // under the key "profilePicture". So you typically DON'T need to include path here.
    // Keeping this only if you use it somewhere else.
    if (includeImageFile && profilePictureFile != null) {
      data['profilePicture'] = profilePictureFile!.path;
    }

    return data;
  }

  // ───────────── TO ENTITY ─────────────
  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      fullName: fullName ?? '',
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture, // will now contain imageUrl value too
    );
  }

  // ───────────── FROM ENTITY ─────────────
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