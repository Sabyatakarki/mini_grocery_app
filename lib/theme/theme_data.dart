import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
<<<<<<< HEAD
    useMaterial3: true,
=======
    useMaterial3: false,
>>>>>>> sprint-2
    fontFamily: 'OpenSansItalic',  
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          color: Color.fromARGB(0, 212, 212, 219),
          fontFamily: 'OpenSansBold',  
        ),
        backgroundColor: Colors.lightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  );
<<<<<<< HEAD
}
=======
}
>>>>>>> sprint-2
