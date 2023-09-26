import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xffEBEDE9),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: const AppBarTheme(
        color: Colors.black, iconTheme: IconThemeData(color: Colors.black)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xffEBEDE9),
      selectedItemColor: Color(0xff91D350),
      unselectedItemColor: Color(0xffEBEDE9),
    ),
    colorScheme: const ColorScheme.light(
      background: Color(0xffEBEDE9),
      primary: Color(0xff46B47D),
      secondary: Color(0xff46B47D),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ));
