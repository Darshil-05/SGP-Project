import 'dart:convert';

import 'package:charusat_recruitment/const.dart';
import 'package:flutter/material.dart';
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
  if (_formKey.currentState?.validate() ?? false) {
   
    final String password = _passwordController.text;  // Assuming you have a TextEditingController for password
    email = _emailController.text ;
    // Set up the API request
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request(
      'POST', 
      Uri.parse('$serverurl/user/signin/')
    );
    
    request.body = json.encode({
      "email":  _emailController.text,
      "password": password
    });
    
    request.headers.addAll(headers);

    // Send the request and handle the response
    http.StreamedResponse response = await request.send();
      debugPrint("Started Login nn process");


    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      debugPrint('Login successful: $responseBody');

      studentid = extractStudentID(email);


 await studentDetails(studentid);




       if (mounted) {
            Navigator.of(context).popAndPushNamed('/home');
          }
    } else {
      debugPrint('Login failed: ${response.reasonPhrase}');
    }
  }
}

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Basic email validation
    final emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
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
                      onTap: _login,
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
                        child: const Center(
                          child: Text(
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
