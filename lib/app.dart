import 'package:flutter/material.dart';
import 'package:mini_grocery/screens/dashboard_screen.dart';

class App extends StatelessWidget {
const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:DashboardScreen(),
    );
  }
}