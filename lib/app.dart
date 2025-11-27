import 'package:flutter/material.dart';
import 'package:mini_grocery/screens/getstartedscreen.dart';

class App extends StatelessWidget {
const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:GetStartedScreen(),
    );
  }
}