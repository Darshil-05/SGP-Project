import 'dart:convert';
import 'package:charusat_recruitment/screens/models/certificate_model.dart';
import 'package:charusat_recruitment/screens/models/experience_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/screens/models/student_model.dart';

class StudentService {
   final FlutterSecureStorage storage = const FlutterSecureStorage();
  Future<Student> getStudentDetails(String studentId) async {
    var url = Uri.parse('$serverurl/student/details/$studentId/');
    
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        // Extracting certificates
        List<Certificate> certificates = [];
        if (jsonData['certificates'] != null) {
          for (var cert in jsonData['certificates']) {
            certificates.add(Certificate(
              id: cert['id'] ?? 0,
              name: cert['name'] ?? "",
              platform: cert['platform'] ?? "",
            ));
          }
        }

        // Extracting experiences
        List<Experience> experiences = [];
        if (jsonData['experience'] != null) {
          for (var exp in jsonData['experience']) {
            experiences.add(Experience(
              id: exp['id'] ?? 0,
              role: exp['role'] ?? "",
              organization: exp['organization'] ?? "",
            ));
          }
        }

        // Creating Student Object
        return Student(
          idNo: jsonData['id_no'] ?? "",
          firstName: jsonData['first_name'] ?? "",
          lastName: jsonData['last_name'] ?? "",
          birthdate: jsonData['birthdate'] ?? "",
          institute: jsonData['institute'] ?? "",
          department: jsonData['department'] ?? "",
          cgpa: (jsonData['cgpa'] ?? 0.0).toDouble(),
          passingYear: jsonData['passing_year'] ?? 0,
          domains: jsonData['domains'] ?? "",
          city: jsonData['city'] ?? "Not Provided",
          programmingSkill: jsonData['programming_skill'] ?? "",
          techSkill: jsonData['tech_skill'] ?? "",
          certificates: certificates,
          experiences: experiences,
        );
      } else {
        throw Exception("Failed to load student details. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error fetching student details: $error");
    }
  }

   Future<bool> addStudent(BuildContext context, Map<String, String> studentData) async {
    var url = Uri.parse('$serverurl/student/students/');
    
    // Retrieve the stored access token
    String? accessToken = await storage.read(key: "access_token");
    print(accessToken);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken', // Add the token here
    };

    try {
      var request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = jsonEncode(studentData);

      http.StreamedResponse response = await request.send();
      http.Response normalResponse = await http.Response.fromStream(response);

      print("Response Code: ${normalResponse.statusCode}");
      print("Response Body: ${normalResponse.body}");

      if (normalResponse.statusCode == 200 || normalResponse.statusCode == 201) {
        if (context.mounted) {
          Navigator.of(context).popAndPushNamed('/home');
        }
        return true;
      } else {
        print("Error: ${normalResponse.reasonPhrase}, Body: ${normalResponse.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error adding student: $e");
      return false;
    }
  }

}
