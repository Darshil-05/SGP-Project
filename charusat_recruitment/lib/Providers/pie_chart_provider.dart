import 'package:flutter/material.dart';

class PieChartProvider with ChangeNotifier {
  String _selectedYear = 'lastYear';

  String get selectedYear => _selectedYear;

  void setSelectedYear(String year) {
    _selectedYear = year;
    notifyListeners(); // Notify listeners to rebuild widgets listening to this provider
  }
}
