import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  bool _isMenuOpen = false;
  int _selectedTab = 0; // Default to home tab (index 0)

  bool get isMenuOpen => _isMenuOpen;
  int get selectedTab => _selectedTab;

  // Toggle the menu state (open/close)
  void toggleMenu() {
    _isMenuOpen = !_isMenuOpen;
    notifyListeners(); // Notify all listeners about the change
  }

  // Set the menu state directly (optional for more flexibility)
  void setMenuState(bool isOpen) {
    _isMenuOpen = isOpen;
    notifyListeners();
  }

  // Set the selected tab index
  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }
}
