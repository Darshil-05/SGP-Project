import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData lightmode = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xff0f1d2c),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: "regularfont"),
        bodyMedium: TextStyle(fontFamily: "regularfont"),
        bodySmall: TextStyle(fontFamily: "regularfont"),
      ),
      scaffoldBackgroundColor: Colors.white);

  static ThemeData darkmode = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xff0f1d2c),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: "regularfont"),
        bodyMedium: TextStyle(fontFamily: "regularfont"),
        bodySmall: TextStyle(fontFamily: "regularfont"),
      ),
      scaffoldBackgroundColor: const Color(0xff181b24));
}
