import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/screens/models/certificate_model.dart';
import 'package:charusat_recruitment/screens/models/experience_model.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';
import '../../notification_service.dart';
import '../../screens/models/student_model.dart';

class StudentService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  
  // Get student details with specific ID - Modified to include context
  Future<StudentProfile> getStudentDetails(BuildContext context, String studentId) async {
    print("Fetching student details for ID: $studentId");
    
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
    
    var url = Uri.parse('$serverurl/student/students-detail-edit/$studentId/');
    
    try {
      var response = await http.get(
        url, 
        headers: headers
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        // Extracting certificates
        List<String> certificates = [];
        if (jsonData['certificates'] != null) {
          for (var cert in jsonData['certificates']) {
            Certificate certificate = Certificate(
              id: cert['id'] ?? 0,
              name: cert['name'] ?? "",
              platform: cert['platform'] ?? "",
            );
            certificates.add(certificate.name);
          }
        }

        // Extracting experiences
        List<String> experiences = [];
        if (jsonData['experience'] != null) {
          for (var exp in jsonData['experience']) {
            Experience experience = Experience(
              id: exp['id'] ?? 0,
              role: exp['role'] ?? "",
              organization: exp['organization'] ?? "",
            );
            experiences.add(experience.role);
          }
        }

        // Creating StudentProfile Object
        return StudentProfile(
          id: jsonData['id'] ?? 0,
          idNo: jsonData['id_no'] ?? "",
          firstName: jsonData['first_name'] ?? "",
          lastName: jsonData['last_name'] ?? "",
          birthdate: DateTime.parse(jsonData['birthdate'] ?? "2000-01-01"),
          institute: jsonData['institute'] ?? "",
          department: jsonData['department'] ?? "",
          cgpa: (jsonData['cgpa'] ?? 0.0).toDouble(),
          passingYear: jsonData['passing_year'] ?? 0,
          domains: jsonData['domains'] ?? "",
          city: jsonData['city'],
          programmingSkill: jsonData['programming_skill'] ?? "",
          techSkill: jsonData['tech_skill'] ?? "",
          certificates: certificates,
          experience: experiences,
        );
      } else if (response.statusCode == 401) {
        // Token expired, attempt to refresh
        bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
        
        if (tokenRefreshed && context.mounted) {
          // Retry with new token
          return getStudentDetails(context, studentId);
        } else {
          throw Exception("Authentication failed. Please login again.");
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load student details. Status Code: ${response.statusCode}"))
          );
        }
        throw Exception("Failed to load student details. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error"))
        );
      }
      throw Exception("Error fetching student details: $error");
    }
  }

  // Get student details for editing - Already has context parameter
  Future<StudentProfile> getStudentDetailsForEdit(BuildContext context, String studentId) async {
    print("Fetching student details for editing - ID: $studentId");
    
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
    
    var url = Uri.parse('$serverurl/student/students-detail-edit/$studentId/');
    
    try {
      var response = await http.get(
        url, 
        headers: headers
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        // Extracting certificates
        List<String> certificates = [];
        if (jsonData['certificates'] != null) {
          for (var cert in jsonData['certificates']) {
            Certificate certificate = Certificate(
              id: cert['id'] ?? 0,
              name: cert['name'] ?? "",
              platform: cert['platform'] ?? "",
            );
            certificates.add(certificate.name);
          }
        }

        // Extracting experiences
        List<String> experiences = [];
        if (jsonData['experience'] != null) {
          for (var exp in jsonData['experience']) {
            Experience experience = Experience(
              id: exp['id'] ?? 0,
              role: exp['role'] ?? "",
              organization: exp['organization'] ?? "",
            );
            experiences.add(experience.role);
          }
        }

        // Creating StudentProfile Object
        return StudentProfile(
          id: jsonData['id'] ?? 0,
          idNo: jsonData['id_no'] ?? "",
          firstName: jsonData['first_name'] ?? "",
          lastName: jsonData['last_name'] ?? "",
          birthdate: DateTime.parse(jsonData['birthdate'] ?? "2000-01-01"),
          institute: jsonData['institute'] ?? "",
          department: jsonData['department'] ?? "",
          cgpa: (jsonData['cgpa'] ?? 0.0).toDouble(),
          passingYear: jsonData['passing_year'] ?? 0,
          domains: jsonData['domains'] ?? "",
          city: jsonData['city'],
          programmingSkill: jsonData['programming_skill'] ?? "",
          techSkill: jsonData['tech_skill'] ?? "",
          certificates: certificates,
          experience: experiences,
        );
      } else if (response.statusCode == 401) {
        // Token expired, attempt to refresh
        bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
        
        if (tokenRefreshed && context.mounted) {
          // Retry with new token
          return getStudentDetailsForEdit(context, studentId);
        } else {
          throw Exception("Authentication failed. Please login again.");
        }
      } else {
        throw Exception("Failed to load student details. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error"))
        );
      }
      throw Exception("Error fetching student details: $error");
    }
  }

  // Add new student - Already has context parameter
  Future<bool> addStudent(BuildContext context, Map<String, dynamic> studentData) async {
    print("Adding new student");
    var url = Uri.parse('$serverurl/student/students-create&list/');
    
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
      request.body = jsonEncode(studentData);

      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 15));
      http.Response normalResponse = await http.Response.fromStream(response);

      print("Response Code: ${normalResponse.statusCode}");
      print("Response Body: ${normalResponse.body}");

      if (normalResponse.statusCode == 200 || normalResponse.statusCode == 201) {
        String token = await NotificationService().initNotifications();

        AuthenticationService().addFcmToken(context, token);
        print("Token have added $token");
        if (context.mounted) {
          Navigator.of(context).popAndPushNamed('/home');
        }
        return true;
      } else if (normalResponse.statusCode == 401) {
        // Token expired, attempt to refresh
        bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
        
        if (tokenRefreshed && context.mounted) {
          // Retry with new token
          return addStudent(context, studentData);
        } else {
          return false;
        }
      } else {
        print("Error: ${normalResponse.reasonPhrase}, Body: ${normalResponse.body}");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add student: ${normalResponse.reasonPhrase}"))
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint("Error adding student: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Network error: $e"))
        );
      }
      return false;
    }
  }

  // Update a specific field - Already has context parameter
  Future<bool> updateStudentField(BuildContext context, String studentId, String fieldName, dynamic value) async {
    print("Updating student field: $fieldName for ID: $studentId");
    var url = Uri.parse('$serverurl/student/details/$studentId/');
    
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

    // Create a map with only the field to update
    Map<String, dynamic> updateData = {
      fieldName: value
    };

    try {
      var response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(updateData),
      ).timeout(const Duration(seconds: 10));

      print("Update Response Code: ${response.statusCode}");
      print("Update Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Update successful
        return true;
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
        
        if (tokenRefreshed && context.mounted) {
          // Retry with new token
          return updateStudentField(context, studentId, fieldName, value);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Session expired. Please login again.')),
            );
            Navigator.of(context).pushReplacementNamed('/login');
          }
          return false;
        }
      } else if (response.statusCode == 400) {
        // Validation error or bad request
        var errorData = json.decode(response.body);
        String errorMessage = 'Failed to update: ${errorData.toString()}';
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
        return false;
      } else {
        // Other errors
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update: ${response.reasonPhrase}')),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint("Error updating student field: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
      return false;
    }
  }

  // Update entire student profile - Already has context parameter
  Future<bool> updateStudentProfile(BuildContext context, String studentId, StudentProfile profile) async {
    print("Updating entire student profile for ID: $studentId");
    var url = Uri.parse('$serverurl/student/details/$studentId/');
    
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
      var response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(profile.toJson()),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        // Update successful
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
        return true;
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
        
        if (tokenRefreshed && context.mounted) {
          // Retry with new token
          return updateStudentProfile(context, studentId, profile);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Session expired. Please login again.')),
            );
            Navigator.of(context).pushReplacementNamed('/login');
          }
          return false;
        }
      } else {
        // Other errors
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: ${response.reasonPhrase}')),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint("Error updating student profile: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
      return false;
    }
  }
  
  // Delete student account - Already has context parameter
  Future<bool> deleteStudentAccount(BuildContext context, String studentId) async {
    print("Deleting student account: $studentId");
    var url = Uri.parse('$serverurl/student/details/$studentId/');
    
    // Retrieve the stored access token
    String? accessToken = await storage.read(key: "access_token");
    
    if (accessToken == null) {
      bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
      if (!tokenRefreshed) return false; // Failed to refresh
      accessToken = await storage.read(key: 'access_token'); // Get new token
    }
    
    var headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var response = await http.delete(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 204) {
        // Deletion successful
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted successfully')),
          );
          // Clear storage and navigate to login
          await storage.deleteAll();
          Navigator.of(context).pushReplacementNamed('/login');
        }
        return true;
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
        
        if (tokenRefreshed && context.mounted) {
          // Retry with new token
          return deleteStudentAccount(context, studentId);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Session expired. Please login again.')),
            );
            Navigator.of(context).pushReplacementNamed('/login');
          }
          return false;
        }
      } else {
        // Other errors
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete account: ${response.reasonPhrase}')),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint("Error deleting student account: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
      return false;
    }
  }

  // Helper function to show error dialog - Already has context parameter
  void _showErrorDialog(BuildContext context, String message) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An Error Occurred'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }
}