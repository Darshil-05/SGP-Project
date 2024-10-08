

import 'package:flutter/material.dart';

const String serverurl = 'http://192.168.48.209:8000/';
late String email;
late String name;
late String password;
late String studentid;
late String dob;
late String cgpa;
late String city;
late String domain;
late String programmingskill;
late String otherskill;
late String institute;
late String department;
late String passingyear;
// late final List<AnnouncementModel> announce ;
void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text('Error'),
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
