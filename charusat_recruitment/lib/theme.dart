import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData lightmode = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xff0f1d2c),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: "regularfont", color: Colors.black),
      bodyMedium: TextStyle(fontFamily: "regularfont", color: Colors.black),
      bodySmall: TextStyle(fontFamily: "regularfont", color: Colors.black),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Color(0xff0f1d2c),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: "regularfont",
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xff0f1d2c), // Change button background color
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0f1d2c), // Updated for newer Flutter versions
        foregroundColor: Colors.white, // Text color
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xff0f1d2c), // Default icon color
    ),
  );

  static ThemeData darkmode = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xff0f1d2c),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: "regularfont", color: Colors.white),
      bodyMedium: TextStyle(fontFamily: "regularfont", color: Colors.white),
      bodySmall: TextStyle(fontFamily: "regularfont", color: Colors.white),
    ),
    scaffoldBackgroundColor: const Color(0xff181b24),
    appBarTheme: const AppBarTheme(
      color: Color(0xff0f1d2c),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontFamily: "regularfont",
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xff0f1d2c), // Change button background color
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0f1d2c), // Updated for newer Flutter versions
        foregroundColor: Colors.white, // Text color
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white, // Default icon color
    ),
  );
}
