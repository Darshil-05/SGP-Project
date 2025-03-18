import 'package:charusat_recruitment/screens/models/faculty_model.dart';

const String serverurl = 'http://192.168.70.209:8000';
String role = 'faculty';
String email="22IT092@charusat.edu.in";
String name = "Darshil Patel";
late String password;
String studentid = '22IT092';
String dob = "05/05/2005";
String cgpa = "8.65";
String city = "Mahesana";
String domain = "App Developer";
String programmingskill = "Flutter , c/c++ , python";
String otherskill = "Problem Solving skill";
String institute = "CSPIT";
String department = "IT";
String passingyear = "2026";

String determineEmailType(String email) {

  return 'faculty';
  // Check if the email is not null or empty
  if (email == null || email.isEmpty) {
    return 'Invalid email';
  }
  
  // Check if email has an @ symbol
  if (!email.contains('@')) {
    return 'Invalid email format';
  }
  
  // Check the domain suffix for classification
  if (email.endsWith('@charusat.edu.in')) {
    return 'student';
  } else if (email.endsWith('@charusat.ac.in')) {
    return 'faculty';
  } else {
    return 'Unknown';
  }
}

String extractIdFromEmail(String email) {
  // Check if the email is not null or empty
  if (email == null || email.isEmpty) {
    return '';
  }
  
  // Split the email by @ and take the first part
  final parts = email.split('@');
  if (parts.length > 0) {
    return parts[0];
  }
  
  // Return empty string if no @ symbol is foun d
  return '';
}