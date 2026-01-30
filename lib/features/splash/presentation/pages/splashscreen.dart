import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mini_grocery/screens/getstartedscreen.dart';
import 'package:mini_grocery/features/dashboard/presentation/pages/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;

  const SplashScreen({
    super.key,
    required this.isLoggedIn,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      if (widget.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GetStartedScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/sales.png', width: 150, height: 150),
            const SizedBox(height: 20),
            const Text(
              "Fresh Picks",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6BAA44),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
