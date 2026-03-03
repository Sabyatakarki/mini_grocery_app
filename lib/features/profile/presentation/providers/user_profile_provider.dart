import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';

final userProfileProvider = StateProvider<ProfileEntity?>((ref) {
  final session = ref.read(userSessionServiceProvider);

  return ProfileEntity(
    userId: session.getCurrentUserId() ?? '',
    fullName: session.getCurrentUserFullName() ?? '',
    email: session.getCurrentUserEmail() ?? '',
    username: session.getCurrentUserUsername() ?? '',
    phoneNumber: session.getCurrentUserPhoneNumber(),
    profilePicture: session.getCurrentUserProfilePicture(),
  );
});
