import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.roboto().toString(),
    scaffoldBackgroundColor: const Color(0xff101014),
    appBarTheme: const AppBarTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff101014),
      selectedItemColor: Color(0xffD2E0FB),
      unselectedItemColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      background: Color(0xff101014),
      primary: Color(0xffD2E0FB),
      secondary: Color(0xff1B1B1C),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
      ),
      titleSmall: TextStyle(color: Colors.grey[400]),
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        color: Colors.grey[400],
      ),
    ));
