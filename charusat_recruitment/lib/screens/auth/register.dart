import 'dart:convert';

import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/screens/auth/registerheader.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureTextPassword = true;
  bool _obscureTextRepeatPassword = true;
  bool _isLoading = false; // New loading state

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
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

  String? _validateRepeatPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please repeat your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

void registerUser() async {
  AuthenticationService authService = AuthenticationService();
  email =_emailController.text;
  bool success = await authService.register(_nameController.text, _emailController.text, _passwordController.text);

  if (success) {
    debugPrint("Registration Successful. Redirecting to OTP verification.");
    if (mounted) {
      Navigator.of(context).pushNamed('/otp');
    }
  } else {
    debugPrint("Registration Failed");
  }
}




  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Color(0xff0f1d2c)),
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xff0f1d2c)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.sizeOf(context).height;
    var screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const RegisterHeader(
              title: "Register",
              subtitle: "Create your account",
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
                    SizedBox(height: screenHeight * 0.04),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Color(0xff0f1d2c)),
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0f1d2c)),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Color(0xff0f1d2c)),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0f1d2c)),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      cursorColor: const Color(0xff0f1d2c),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Color(0xff0f1d2c)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextPassword ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xff0f1d2c),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextPassword = !_obscureTextPassword;
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
                      ),
                      obscureText: _obscureTextPassword,
                      validator: _validatePassword,
                      cursorColor: const Color(0xff0f1d2c),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      controller: _repeatPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Color(0xff0f1d2c)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextRepeatPassword ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xff0f1d2c),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextRepeatPassword = !_obscureTextRepeatPassword;
                            });
                          },
                        ),
                        labelText: 'Repeat Password',
                        labelStyle: const TextStyle(color: Color(0xff0f1d2c)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0f1d2c)),
                        ),
                      ),
                      obscureText: _obscureTextRepeatPassword,
                      validator: _validateRepeatPassword,
                      cursorColor: const Color(0xff0f1d2c),
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    GestureDetector(
                      onTap: _isLoading ? null : registerUser,
                      child: Container(
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.8,
                        decoration: BoxDecoration(
                          color: const Color(0xff0f1d2c),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              offset: const Offset(0, 10),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            child: Text(
                          "Do you have an account ?  ",
                          style: TextStyle(fontSize: 18),
                        )),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .popAndPushNamed('/login');
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    )
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
