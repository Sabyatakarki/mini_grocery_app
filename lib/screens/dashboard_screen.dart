import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Screen"),
        backgroundColor: Colors.lightGreen,
      ),

      body: const Center(
        child: Text(
          "Welcome to Dashboard ",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
