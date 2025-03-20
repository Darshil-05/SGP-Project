import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';
import 'package:charusat_recruitment/screens/models/faculty_model.dart';

class FacultyService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  
  // Add new faculty
  Future<bool> addFaculty(BuildContext context, Map<String, String> facultyData) async {
    print("Adding new faculty");
    var url = Uri.parse('$serverurl/faculty/faculty-details/');
    
    // Retrieve the stored access token
    String? accessToken = await storage.read(key: "access_token");
    
    if (accessToken == null) {
      bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
      if (!tokenRefreshed) return false; // Failed to refresh
      accessToken = await storage.read(key: 'access_token'); // Get new token
    }
    
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = jsonEncode(facultyData);

      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 15));
      http.Response normalResponse = await http.Response.fromStream(response);

      print("Response Code: ${normalResponse.statusCode}");
      print("Response Body: ${normalResponse.body}");

      if (normalResponse.statusCode == 200 || normalResponse.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faculty added successfully')),
          );
        }
        return true;
      } else if (normalResponse.statusCode == 401) {
        // Token expired, attempt to refresh
        bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
        
        if (tokenRefreshed && context.mounted) {
          // Retry with new token
          return addFaculty(context, facultyData);
        } else {
          return false;
        }
      } else {
        print("Error: ${normalResponse.reasonPhrase}, Body: ${normalResponse.body}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add faculty: ${normalResponse.reasonPhrase}"))
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint("Error adding faculty: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Network error: $e"))
        );
      }
      return false;
    }
  }

  // Get faculty details
  Future<FacultyProfile> getFacultyDetails(BuildContext context, String facultyId) async {
    print("Fetching faculty details for ID: $facultyId");
    
    String? accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
      if (!tokenRefreshed) {
        throw Exception("Authentication failed. Please login again.");
      }
      accessToken = await storage.read(key: 'access_token'); // Get new token
    }

    var headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    
    var url = Uri.parse('$serverurl/faculty/faculty-details/$facultyId/');
    
    try {
      var response = await http.get(
        url, 
        headers: headers
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        // Creating FacultyProfile Object
        return FacultyProfile(
          id: jsonData['id'] ?? 0,
          facultyId: jsonData['faculty_id'] ?? "",
          firstName: jsonData['first_name'] ?? "",
          lastName: jsonData['last_name'] ?? "",
          institute: jsonData['institute'] ?? "",
          department: jsonData['department'] ?? "",
        );
      } else if (response.statusCode == 401) {
        // Token expired, attempt to refresh
        bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
        
        if (tokenRefreshed && context.mounted) {
          // Retry with new token
          return getFacultyDetails(context, facultyId);
        } else {
          throw Exception("Authentication failed. Please login again.");
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load faculty details. Status Code: ${response.statusCode}"))
          );
        }
        throw Exception("Failed to load faculty details. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error"))
        );
      }
      throw Exception("Error fetching faculty details: $error");
    }
  }
}