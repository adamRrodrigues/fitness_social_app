import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: GoogleFonts.roboto().toString(),
    scaffoldBackgroundColor: const Color(0xffE3E3E3),
    iconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
        color: Colors.black,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xffE3E3E3),
      selectedItemColor: Color(0xffD2E0FB),
      unselectedItemColor: Colors.black,
    ),
    colorScheme: const ColorScheme.light(
      background: Color(0xffE3E3E3),
      primary: Color(0xffD2E0FB),
      secondary: Color(0xffF2F3F3),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black87),
    ));
