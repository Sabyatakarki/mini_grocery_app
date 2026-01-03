import 'package:flutter/material.dart';
import 'package:mini_grocery/features/splash/presentation/pages/splashscreen.dart';
import 'package:mini_grocery/app/theme/appbar_theme.dart';
import 'package:mini_grocery/app/theme/buttom_navigationbar_theme_data.dart';
import 'package:mini_grocery/app/theme/inputdecoration_theme.dart';
import 'package:mini_grocery/app/theme/theme_data.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Grocery',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme().copyWith(
        appBarTheme: getAppBarTheme(),
        inputDecorationTheme: getinputdecorationtheme(),
        bottomNavigationBarTheme: getBottomNavigationBarTheme(),
      ),
      home: SplashScreen(isLoggedIn: isLoggedIn),
    );
  }
}
