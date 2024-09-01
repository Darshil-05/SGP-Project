import 'package:flutter/material.dart';

class AnnouncementModel {
  AnnouncementModel({
    this.id,
    this.title = "",
    this.subtitle = "",
    this.companyName,
    this.color = Colors.white,
  });

  UniqueKey? id = UniqueKey();
  String title, subtitle;
  String? companyName;
  Color color;

  static List<AnnouncementModel> annouce  = [
    AnnouncementModel(
      title: "New company Arriving",
      subtitle: "New tech Company arriving for placement drive on 21st march",
      companyName: "tatva soft",
      color: const Color(0xff7850f0)
    ),
    AnnouncementModel(
      title: "Form to be closed",
      subtitle: "Form will be closed on 20 march 12:00 A.M. onwards",
      companyName: "tatva soft",
      color: const Color(0xff6792ff)
    ),
    AnnouncementModel(
      title: "Mandetory registration",
      subtitle: "All student have to register to hightech company",
      companyName: "From CDPC",
      color: const Color(0xff005fe7)
    ),
  ];
}
