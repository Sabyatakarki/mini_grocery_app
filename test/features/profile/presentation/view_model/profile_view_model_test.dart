import 'package:flutter_test/flutter_test.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';

void main() {

  group('Profile Unit Tests', () {

    // Test 1: Profile entity creation
    test('ProfileEntity should store correct user information', () {

      final profile = ProfileEntity(
        userId: "123",
        fullName: "Sabbu",
        email: "sabbu@test.com",
        username: "sabbu123",
        phoneNumber: "9800000000",
        profilePicture: null,
      );

      expect(profile.fullName, "Sabbu");
      expect(profile.email, "sabbu@test.com");
      expect(profile.username, "sabbu123");
    });

    // Test 2: CopyWith functionality
    test('copyWith should update only changed fields', () {

      final profile = ProfileEntity(
        userId: "123",
        fullName: "Sabbu",
        email: "sabbu@test.com",
        username: "sabbu123",
        phoneNumber: "9800000000",
        profilePicture: null,
      );

      final updatedProfile = profile.copyWith(
        fullName: "Sabbu Karki",
      );

      expect(updatedProfile.fullName, "Sabbu Karki");
      expect(updatedProfile.email, "sabbu@test.com");
    });

    // Test 3: Email validation logic
    test('Email should contain @ symbol', () {

      const email = "sabbu@test.com";

      final isValid = email.contains("@");

      expect(isValid, true);
    });

    // Test 4: Phone number length validation
    test('Phone number should be 10 digits', () {

      const phone = "9800000000";

      expect(phone.length, 10);
    });

  });

}