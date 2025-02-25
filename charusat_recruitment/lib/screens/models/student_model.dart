import 'package:charusat_recruitment/screens/models/certificate_model.dart';
import 'package:charusat_recruitment/screens/models/experience_model.dart';

class Student {
  final String idNo;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String institute;
  final String department;
  final double cgpa;
  final int passingYear;
  final String domains;
  final String city;
  final String programmingSkill;
  final String techSkill;
  final List<Certificate> certificates;
  final List<Experience> experiences;

  Student({
    required this.idNo,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.institute,
    required this.department,
    required this.cgpa,
    required this.passingYear,
    required this.domains,
    required this.city,
    required this.programmingSkill,
    required this.techSkill,
    required this.certificates,
    required this.experiences,
  });
}