import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:charusat_recruitment/const.dart';

import '../../notification_service.dart';

class AuthenticationService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  

  /// **Login Function**
  Future<int> login(String email, String password) async {
    var url = Uri.parse('$serverurl/user/signin/');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({"email": email, "password": password});
    print("started Login");
    try {
      var response = await http.post(url, headers: headers, body: body);
      print("started Login called"  );
        var responseBody = json.decode(response.body);
        print(responseBody.toString());
      if (response.statusCode == 200) {
        String accessToken = responseBody['access'];
        String refreshToken = responseBody['refresh'];
    print("Logged in");
        // Store tokens securely
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
        await _storage.write(key: 'email', value: email);
       print("email from loging is $email");
        role = determineEmailType(email);
        return 1; // Login successful
      }else if(response.statusCode == 400){
        return 2;
      }
       else {
        throw Exception("Login failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error logging in: $e");
    }
  }
  // fcm add
  Future<bool> addFcmToken(BuildContext context, String fcmToken) async {
  print("Adding FCM token for student... updated");
  studentid = extractIdFromEmail(email);
  // Get access token using the same pattern as in getAnnouncements
  String? accessToken = await secureStorage.read(key: 'access_token');

  if (accessToken == null) {
    bool tokenRefreshed =
        await AuthenticationService().regenerateAccessToken(context);
    if (!tokenRefreshed) return false; // Redirected to login if refresh fails
    accessToken =
        await secureStorage.read(key: 'access_token'); // Get new token
  }

  var headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  var body = {
    "student_idno": studentid,
    "token": fcmToken,
  };

  try {
    var response = await http
        .post(
          Uri.parse('$serverurl/announcement/fcm/student/'),
          headers: headers,
          body: json.encode(body),
        )
        .timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("FCM token added successfully");
      return true;
    } else if (response.statusCode == 401) {
      // If Unauthorized, attempt to regenerate token and retry
      bool tokenRefreshed = await AuthenticationService().regenerateAccessToken(context);
      if (tokenRefreshed) {
        return await addFcmToken(context, fcmToken); // Retry adding FCM token
      }
      return false;
    } else {
      print("Error adding FCM token: ${response.statusCode}, ${response.body}");
      return false;
    }
  } catch (e) {
    print("Exception adding FCM token: $e");
    return false;
  }
}
  /// **Registration Function**
 Future<int> register(String name, String email, String password) async {
  var url = Uri.parse('$serverurl/user/signup/');
  var headers = {'Content-Type': 'application/json'};
  var body = jsonEncode({
    "name": name,
    "email": email,
    "password": password,
    "confirm_password": password
  });
  print("started register calling");
  
  try {
    var response = await http.post(url, headers: headers, body: body);
    print("started register ${response.statusCode}");
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return 1; // Registration successful (equivalent to true)
    } else if (response.statusCode == 400) {
      return 2; // User already exists or invalid email
    } else {
      print("Registration failed: ${response.reasonPhrase}");
      return 0; // Other errors
    }
  } catch (e) {
    print("Error registering: $e");
    return 0; // Exception occurred
  }
}
//otp verification 
Future<bool> verifyOtp(String email, String otp) async {
  var url = Uri.parse('$serverurl/user/verify-otp/');
  var headers = {'Content-Type': 'application/json'};
  var body = jsonEncode({"email": email, "otp_code": otp ,  "name" : name,"password" : "Abcd@123" ,});

  print("Started verifying OTP...");

  try {
    var response = await http.post(url, headers: headers, body: body);

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = jsonDecode(response.body);

      // Extract tokens
      String accessToken = responseData["access"];
      String refreshToken = responseData["refresh"];

      // Store tokens securely
      await _storage.write(key: "access_token", value: accessToken);
      await _storage.write(key: "refresh_token", value: refreshToken);
      await _storage.write(key: "email", value: email);

      print("Tokens stored successfully!");
      await NotificationService().initNotifications();
      role = determineEmailType(email);
      return true; // OTP verification successful
    } else {
      print("OTP verification failed: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error verifying OTP: $e");
    return false;
  }
}


  /// **Get Access Token**
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  /// **Get Refresh Token**
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  /// **Logout (Clear Tokens)**
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    print("sucess logout");
  }

  /// **Regenrate accesstoken**
   Future<bool> regenerateAccessToken(BuildContext context) async {
    String? refreshToken = await _storage.read(key: 'refresh_token');
    print("calling new refresh token");
    if (refreshToken == null) {
      _redirectToLogin(context);
      return false;
    }

    try {
      var response = await http.post(
        Uri.parse('$serverurl/user/token/refresh/'), // Replace with actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"refresh": refreshToken}),
      );
      print("new refresh has been generated");
      print(response.body.toString());
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        await _storage.write(key: 'access_token', value: responseBody['access']);
        await _storage.write(key: 'refresh_token', value: responseBody['refresh']);
        return true; 
      } else if (response.statusCode == 401) {
        _redirectToLogin(context);
      }
    } catch (e) {
      debugPrint("Error refreshing token: $e");
      _redirectToLogin(context);
    }

    return false; // Failed to refresh token
  }

  void _redirectToLogin(BuildContext context) {
    _storage.deleteAll(); // Clear stored tokens
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
