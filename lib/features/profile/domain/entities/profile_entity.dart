import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? profilePicture;

  const ProfileEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.profilePicture,
  });

  ProfileEntity copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? username,
    String? phoneNumber,
    String? profilePicture,
  }) {
    return ProfileEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fullName,
        email,
        username,
        phoneNumber,
        profilePicture,
      ];
}