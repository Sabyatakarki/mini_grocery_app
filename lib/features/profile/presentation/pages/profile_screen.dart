import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/auth/presentation/pages/loginpagescreen.dart';
import 'edit_profile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(userSessionServiceProvider);

    // Fetch credentials from SharedPreferences
    final fullName = session.getCurrentUserFullName() ?? "";
    final email = session.getCurrentUserEmail() ?? "";
    final phone = session.getCurrentUserPhoneNumber() ?? "";
    final profilePicPath = session.getCurrentUserProfilePicture();

    ImageProvider? profileImage;
    if (profilePicPath != null && profilePicPath.isNotEmpty) {
      final file = File(profilePicPath);
      if (file.existsSync()) profileImage = FileImage(file);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: profileImage,
              child: profileImage == null
                  ? const Icon(Icons.person, size: 55, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 24),

            _profileTile("Full Name", fullName),
            _profileTile("Email", email),
            _profileTile("Phone", phone),
            _profileTile("Password", "********"),

            const Spacer(),

            // Edit Profile
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                  // Force rebuild after returning from EditProfileScreen
                  (context as Element).reassemble();
                },
                child: const Text("Edit Profile", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 16),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await session.clearSession(); // Clear SharedPreferences

                    // Navigate back to GetStarted/Login
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Flexible(
            child: Text(value, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
