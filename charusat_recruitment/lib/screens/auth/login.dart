import 'package:flutter/material.dart';
import 'loginheader.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform login logic
      print('Login successful');
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            child: Text(
                          "Don't have an account ?  ",
                          style: TextStyle(fontSize: 18),
                        )),
                        SizedBox(
                            child: Text(
                          "Register",
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
