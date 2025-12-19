import 'package:flutter/material.dart';

BottomNavigationBarThemeData getBottomNavigationBarTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: Colors.lightGreen,
<<<<<<< HEAD
    selectedItemColor: Colors.black12,
    unselectedItemColor: Colors.white,
=======
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.black54,
>>>>>>> sprint-2
    selectedLabelStyle: const TextStyle(
      fontFamily: 'OpenSans-Bold',
      fontSize: 14,
    ),
    unselectedLabelStyle: const TextStyle(
      fontFamily: 'OpenSans-Regular',
      fontSize: 12,
    ),
  );
}