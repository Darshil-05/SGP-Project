import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  bool _isMenuOpen = false;

  bool get isMenuOpen => _isMenuOpen;

  // Toggle the menu state (open/close)
  void toggleMenu() {
    _isMenuOpen = !_isMenuOpen;
    notifyListeners();  // Notify all listeners about the change
  }

  // Set the menu state directly (optional for more flexibility)
  void setMenuState(bool isOpen) {
    _isMenuOpen = isOpen;
    notifyListeners();
  }
}
