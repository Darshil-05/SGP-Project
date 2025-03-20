import 'dart:convert';

import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';
import 'package:flutter/material.dart';
import '../../notification_service.dart';
import 'loginheader.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Add this line to track loading state
  

Future<void> studentDetails(String studentId) async {

  var request = http.Request('GET', Uri.parse('$serverurl/student/students/'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // Step 2: Parse the response
    String responseBody = await response.stream.bytesToString();
    List<dynamic> jsonData = json.decode(responseBody);
  // debugPrint(jsonData.toString());
    // Step 3: Search for student by id and initialize variables
    for (var student in jsonData) {
      debugPrint(student['id_no'].toString().toLowerCase());
      if (student['id_no'].toString().toLowerCase() == studentId.toLowerCase()) {
        debugPrint("here");
        name = student['first_name'] + " " + student ['last_name'] ?? " ";
        dob = student['birthdate'] ?? '';
        cgpa = student['cgpa'].toString();
        city = student['city'] ?? '';
        domain = student['domains'] ?? '';
        programmingskill = student['programming_skill'] ?? '';
        otherskill = student['tech_skill'] ?? '';
        institute = student['institute'] ?? '';
        department = student['department'] ?? '';
        passingyear = student['passing_year'].toString();
        print("Data initialized for student ID: $studentId");
        return; // Exit the function once data is found and initialized
      }
    }
    print("Student ID not found.");
  } else {
    print("Failed to fetch data: ${response.reasonPhrase}");
  }
}
String extractStudentID(String email) {
  
  if (email.contains('@')) {
    return email.split('@')[0]; 
  } else {
    return 'Invalid email';
  }
}
  void _login() async {
    // Set loading state to true before starting the login process
    setState(() {
      _isLoading = true;
    });
    
    AuthenticationService authService = AuthenticationService();
    email = _emailController.text;
    password = _passwordController.text;

    
    int success = await authService.login(_emailController.text, _passwordController.text);
    
    // Set loading state back to false after login process completes
    setState(() {
      _isLoading = false;
    });
    
    print("sucess is $success");
    if (success == 1) {
       String token = await NotificationService().initNotifications();
        AuthenticationService().addFcmToken(context, token);
        print("Token have added $token");
      print("Login Successful");
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else if(success == 2) {
      showInvalidCredentialsDialog(context);
    } else {
      print("Login Failed");
    }
  }

void showInvalidCredentialsDialog(BuildContext context, {String message = "Invalid username or password. Please try again."}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Authentication Error"),
        content: Text(message),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


 String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  
  final emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegExp.hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  // Check if email ends with either @charusat.edu.in or @charusat.ac.in
  if (!value.endsWith('@charusat.edu.in') && !value.endsWith('@charusat.ac.in')) {
    return 'Email must end with @charusat.edu.in or @charusat.ac.in';
  }
  
  // Basic email validation for format
  
  return null;
}

  String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  
  // Check for at least one uppercase letter
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Password must contain at least one capital letter';
  }
  
  // Check for at least one lowercase letter
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Password must contain at least one small letter';
  }
  
  // Check for at least one special character
  if (!RegExp(r'[@#$_\-!]').hasMatch(value)) {
    return 'Password must contain at least one special symbol (@, #, \$, _, -, !)';
  }
  
  return null;
}

  bool _obscureText = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LoginHeader(
              title: "Sign in to your",
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.04),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xff0f1d2c),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0f1d2c)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0f1d2c)),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      cursorColor: const Color(
                          0xff0f1d2c), // Optional: Change the cursor color
                    ),
                    SizedBox(height: height * 0.04),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xff0f1d2c),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xff0f1d2c),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Color(0xff0f1d2c)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0f1d2c)),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0f1d2c)),
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: _validatePassword,
                      cursorColor: const Color(
                          0xff0f1d2c), // Optional: Change the cursor color
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot');
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.035),
                    GestureDetector(
                      onTap: _isLoading ? null : _login, // Disable tap when loading
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                            color: const Color(0xff0f1d2c),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: -3,
                                  offset: const Offset(3, 3),
                                  blurRadius: 10)
                            ]),
                        child: Center(
                          child: _isLoading 
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              ) 
                            : const Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    letterSpacing: 3),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            child: Text(
                          "Don't have an account ?  ",
                          style: TextStyle(fontSize: 18),
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).popAndPushNamed('/register');
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}