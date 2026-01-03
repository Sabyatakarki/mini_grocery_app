import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/services/hive/hive_service.dart';
import 'package:mini_grocery/screens/getstartedscreen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // Show confirmation dialog
          bool? confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
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
            final hiveService = ref.read(hiveServiceProvider);

            // Clear session
            await hiveService.clearLoginSession();

            // Navigate to GetStartedScreen and remove backstack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const GetStartedScreen(),
              ),
              (route) => false,
            );
          }
        },
        child: const Text('Logout'),
      ),
    );
  }
}
