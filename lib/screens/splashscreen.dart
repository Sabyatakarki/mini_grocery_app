import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mini_grocery/screens/onboardingscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay 2 seconds then go to onboarding screen
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Onboardingscreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // match your app theme
      body: Center(
        child: Image.asset(
          'assets/images/sales.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
