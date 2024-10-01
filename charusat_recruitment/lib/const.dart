import 'dart:html';

import 'package:charusat_recruitment/screens/models/announcement_model.dart';
import 'package:flutter/material.dart';

const String url = 'http://192.168.98.209:8000/';
late String email;
late List<AnnouncementModel> announce;
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
