import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.roboto().toString(),
    scaffoldBackgroundColor: const Color(0xff222831),
    appBarTheme: const AppBarTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff222831),
      selectedItemColor: Color(0xff00ADB5),
      unselectedItemColor: Colors.white,
    ),
    colorScheme: const ColorScheme.dark(
      background: Color(0xff222831),
      primary: Color(0xff00ADB5),
      secondary: Color(0xff393E46),
    ),
    textTheme:  TextTheme(
  
      titleLarge: TextStyle(
        color: Colors.white,
        
      ),
      titleMedium: TextStyle(
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        color: Colors.grey[400]
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        color: Colors.grey[400],
      ),
    ));
