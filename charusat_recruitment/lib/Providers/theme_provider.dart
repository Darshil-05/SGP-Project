import 'package:flutter/material.dart';

class Themechange with ChangeNotifier{
  var _themeMode =ThemeMode.light;

  ThemeMode get themeMode =>_themeMode;

  void setTheme(thememode){
    _themeMode = thememode;
    notifyListeners();
  }
}