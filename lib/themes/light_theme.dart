import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: GoogleFonts.roboto().toString(),
    scaffoldBackgroundColor: const Color(0xffEBEBEF),
    iconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
        color: Colors.black,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xffEBEBEF),
      selectedItemColor: Color(0xff373748),
      unselectedItemColor: Colors.black,
    ),
    colorScheme: const ColorScheme.light(
        background: Color(0xffEBEBEF),
        primary: Color(0xff15F5BA),
        onPrimary: Colors.black,
        secondary: Color(0xffF0F3FF),
        onSecondary: Colors.black,
        surface: Color(0xffE2E2E4)),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black87),
    ));
