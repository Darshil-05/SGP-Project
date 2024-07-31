import 'package:flutter/material.dart';

class ThemeManager{



  static ThemeData lightmode=ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xff0f1d2c),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: "regularfont" ),
      bodyMedium: TextStyle(fontFamily: "regularfont" ),
      bodySmall: TextStyle(fontFamily: "regularfont" ),
    )
  ); 

  static ThemeData darkmode=ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xff0f1d2c),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: "regularfont" ),
      bodyMedium: TextStyle(fontFamily: "regularfont" ),
      bodySmall: TextStyle(fontFamily: "regularfont" ),
    )
  );


}