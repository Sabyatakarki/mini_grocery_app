import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/app/app.dart';
import 'package:mini_grocery/core/services/hive/hive_service.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI styles
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.init();

  // SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();

  // Check if user is logged in
  final isLoggedIn = sharedPreferences.getBool('is_logged_in') ?? false;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: App(isLoggedIn: isLoggedIn),
    ),
  );
}
