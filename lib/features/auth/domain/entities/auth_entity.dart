import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String authId;
  final String email;
  final String? password;
  final String? fullName;
  final String? username;
  final String? phoneNumber;
  final String? profilePicture;
  final String? batchId;

  const AuthEntity({
    required this.authId,
    required this.email,
    this.password,
    this.fullName,
    this.username,
    this.phoneNumber,
    this.profilePicture,
    this.batchId,
  });

  @override
  List<Object?> get props => [authId, email, password, fullName, username, phoneNumber, profilePicture, batchId];
}
