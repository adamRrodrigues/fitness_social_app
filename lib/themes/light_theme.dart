import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffE6E9EA),
    iconTheme: const IconThemeData(color: Colors.black),
    appBarTheme:  const AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.black)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xffE6E9EA),
      selectedItemColor: Color(0xffFF69B4),
      unselectedItemColor: Color(0xffE6E9EA),
    ),
    colorScheme: const ColorScheme.light(
      background: Color(0xffE6E9EA),
      primary: Color(0xffFF69B4),
      secondary: Color(0xffffffff),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ));
