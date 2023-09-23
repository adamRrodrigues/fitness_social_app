import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: Color(0xfff0f0f0),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
        color: Colors.black, iconTheme: IconThemeData(color: Colors.black)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xfff0f0f0),
      selectedItemColor: Colors.black,
      unselectedItemColor: Color(0xfff0f0f0),
    ),
    colorScheme: const ColorScheme.light(
      background: Color(0xfff0f0f0),
      primary: Colors.black,
      secondary: Color(0xfffbfcfe),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ));
