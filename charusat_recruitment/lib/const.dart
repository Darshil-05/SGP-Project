import 'package:flutter/material.dart';
const String serverurl = 'http://172.25.197.209:8000';
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
void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
