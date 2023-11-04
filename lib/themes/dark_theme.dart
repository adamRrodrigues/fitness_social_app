import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff000000),
    appBarTheme: const AppBarTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff000000),
      selectedItemColor: Color(0xffFF69B4),
      unselectedItemColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      background: Color(0xff000000),
      primary: Color(0xffFF69B4),
      secondary: Color(0xff151718),
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
