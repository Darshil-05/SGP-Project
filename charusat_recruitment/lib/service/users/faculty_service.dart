import 'dart:convert';
import 'package:charusat_recruitment/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FacultyService {
  Future<bool> addFaculty(BuildContext context, Map<String, String> facultyData) async {
    try {
      final response = await http.post(
        Uri.parse('$serverurl/faculty/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(facultyData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Faculty added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to previous screen
        return true;
      } else {
        // Handle error response
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Failed to add faculty';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  // You can add more methods here as needed, such as:
  // getFacultyDetails, updateFaculty, deleteFaculty, etc.
}