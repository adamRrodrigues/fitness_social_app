import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffEBEDEF),
    iconTheme: const IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
        color: Colors.black, iconTheme: IconThemeData(color: Colors.black)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xffEBEDEF),
      selectedItemColor: Color(0xff91D350),
      unselectedItemColor: Color(0xffEBEDEF),
    ),
    colorScheme: const ColorScheme.light(
      background: Color(0xffEBEDEF),
      primary: Color(0xff91D350),
      secondary: Color(0xff46B47D),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ));
