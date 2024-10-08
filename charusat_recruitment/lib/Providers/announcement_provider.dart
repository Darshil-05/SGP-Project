import 'package:charusat_recruitment/screens/models/announcement_model.dart';
import 'package:flutter/material.dart';

class AnnouncementProvider with ChangeNotifier {
  // List to hold the announcements
  List<AnnouncementModel> _announcements = [];

  // Getter for announcements list
  List<AnnouncementModel> get announcements => _announcements;

  // Setter for announcements list
  set announcements(List<AnnouncementModel> announcements) {
    _announcements = announcements;
    notifyListeners(); // Notify listeners when data changes
  }

  // Method to add an announcement
  void addAnnouncement(AnnouncementModel announcement) {
    _announcements.add(announcement);
    notifyListeners(); // Notify listeners after adding
  }

  // Method to remove an announcement
   void removeAnnouncementById(int id) {
    
    _announcements.removeWhere((announcement) => announcement.id == id);
    notifyListeners(); // Notify listeners after removing
  }
}
