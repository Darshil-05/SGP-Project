import 'package:flutter/material.dart';

const String serverurl = 'http://172.28.184.209:8000/';
late String email;
String name = "";
late String password;
late String studentid;
String dob = " ";
String cgpa = " ";
String city = " ";
String domain = " ";
String programmingskill = " ";
String otherskill = " ";
String institute = " ";
String department = " ";
String passingyear = " ";
// late final List<AnnouncementModel> announce ;
void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
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
