import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xff101214),
    appBarTheme: const AppBarTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      selectedItemColor: Color(0xff91D350),
      unselectedItemColor: Color(0xff001913),
    ),
    colorScheme: const ColorScheme.dark(
      background: Color(0xff101214),
      primary: Color(0xff91D350),
      secondary: Color(0xff46B47D),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
      ),
    ));
