import 'package:charusat_recruitment/screens/auth/registerheader.dart';
import 'package:flutter/material.dart';

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

  bool _obscureTextPassword = true;
  bool _obscureTextRepeatPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform registration logic
      print('Registration successful');
    }
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
                        prefixIcon:
                            Icon(Icons.person, color: Color(0xff0f1d2c)),
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
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0xff0f1d2c)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
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
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0xff0f1d2c)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextRepeatPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xff0f1d2c),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextRepeatPassword =
                                  !_obscureTextRepeatPassword;
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
                      onTap: _register,
                      child: Container(
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.8,
                        decoration: BoxDecoration(
                          color: const Color(0xff0f1d2c),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: -3,
                              offset: const Offset(3, 3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            child: Text(
                          "I have an account ? ",
                          style: TextStyle(fontSize: 16),
                        )),
                        SizedBox(
                            child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 16,
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
