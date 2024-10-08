import 'package:flutter/material.dart';

class AnnouncementModel {
  final int id;
  final String title;
  final String subtitle;
  final String companyName;
  final Color color;

  AnnouncementModel({
    required this.id, // unique ID
    required this.title,
    required this.subtitle,
    required this.companyName,
    required this.color,
  });

  // static List<AnnouncementModel> annouce  = [
  //   AnnouncementModel(
  //     id: UniqueKey(),
  //     title: "New company Arriving",
  //     subtitle: "New tech Company arriving for placement drive on 21st march",
  //     companyName: "tatva soft",
  //     color: const Color(0xff7850f0)
  //   ),
  //   AnnouncementModel(
  //     id: UniqueKey(),
  //     title: "Form to be closed",
  //     subtitle: "Form will be closed on 20 march 12:00 A.M. onwards",
  //     companyName: "tatva soft",
  //     color: const Color(0xff6792ff)
  //   ),
  //   AnnouncementModel(
  //     id: UniqueKey(),
  //     title: "Mandetory registration",
  //     subtitle: "All student have to register to hightech company",
  //     companyName: "From CDPC",
  //     color: const Color(0xff005fe7)
  //   ),
  // ];
}

// class AnnouncementModel {
//   class AnnouncementModel {
//   final String id;
//   final String title;
//   final String subtitle;
//   final String companyName;
//   final Color color;

//   AnnouncementModel({
//     required this.id, // unique ID
//     required this.title,
//     required this.subtitle,
//     required this.companyName,
//     required this.color,
//   });


  // static List<AnnouncementModel> annouce  = [
  //   AnnouncementModel(
  //     title: "New company Arriving",
  //     subtitle: "New tech Company arriving for placement drive on 21st march",
  //     companyName: "tatva soft",
  //     color: const Color(0xff7850f0)
  //   ),
  //   AnnouncementModel(
  //     title: "Form to be closed",
  //     subtitle: "Form will be closed on 20 march 12:00 A.M. onwards",
  //     companyName: "tatva soft",
  //     color: const Color(0xff6792ff)
  //   ),
  //   AnnouncementModel(
  //     title: "Mandetory registration",
  //     subtitle: "All student have to register to hightech company",
  //     companyName: "From CDPC",
  //     color: const Color(0xff005fe7)
  //   ),
  // ];
// }
// }