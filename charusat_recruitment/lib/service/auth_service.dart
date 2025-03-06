import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:charusat_recruitment/const.dart';

class AuthenticationService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  

  /// **Login Function**
  Future<bool> login(String email, String password) async {
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
        String accessToken = responseBody['access_token'];
        String refreshToken = responseBody['refresh_token'];

        // Store tokens securely
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);

        return true; // Login successful
      } else {
        throw Exception("Login failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error logging in: $e");
    }
  }

  /// **Registration Function**
  Future<bool> register(String name, String email, String password) async {
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
        return true; // Registration successful
      } else {
        throw Exception("Registration failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error registering: $e");
    }
  }

//otp verification 
Future<bool> verifyOtp(String email, String otp) async {
  var url = Uri.parse('$serverurl/user/verify-otp/');
  var headers = {'Content-Type': 'application/json'};
  var body = jsonEncode({"email": email, "otp_code": otp});

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

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        await _storage.write(key: 'access_token', value: responseBody['access']);
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
