import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/api/api_endpoints.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/auth/presentation/pages/loginpagescreen.dart';
import 'package:mini_grocery/features/profile/presentation/view_model/profile_view_model.dart';
import 'edit_profile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String? _buildProfileImageUrl(String? raw, int version) {
    if (raw == null || raw.trim().isEmpty) return null;

    // Remove any accidental file:// or file:/// prefix
    raw = raw.replaceFirst('file:///', '/').replaceFirst('file://', '/');


    if (raw.startsWith('/public/profile_pictures/')) {
      raw = raw.replaceFirst(
        '/public/profile_pictures/',
        '/uploads/profile_pictures/',
      );
    }

    // Already full URL
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return "$raw?v=$version";
    }

    // Ensure leading slash
    if (!raw.startsWith('/')) raw = '/$raw';

    return "${ApiEndpoints.baseUrl}$raw?v=$version";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final profile = state.profile;

    final fullName = profile?.fullName ?? "—";
    final email = profile?.email ?? "—";
    final phone = profile?.phoneNumber ?? "—";
    final profilePic = profile?.profilePicture;

    final imageUrl = _buildProfileImageUrl(profilePic, state.imageVersion);
    final ImageProvider? profileImage =
        imageUrl == null ? null : NetworkImage(imageUrl);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: profileImage,
              child: profileImage == null
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 14),
            Text(
              fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            _profileTile("Email", email),
            _profileTile("Phone", phone),
            _profileTile("Password", "********"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final session = ref.read(userSessionServiceProvider);
                    await session.clearSession();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  }
                },
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
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}