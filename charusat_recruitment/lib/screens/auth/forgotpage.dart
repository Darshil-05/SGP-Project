import 'package:charusat_recruitment/screens/auth/registerheader.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _emailController = TextEditingController();

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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Column(
                children: [

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
                    cursorColor: const Color(0xff0f1d2c),
                  ),
                  
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.9,
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
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );



    return Scaffold(
      body: Column(
        children: [
          const RegisterHeader(
            title: "Forgot Password",
            subtitle: "Enter your email",
            navigator: true,
          ),
          SizedBox(height: screenHeight * 0.02),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                    cursorColor: const Color(0xff0f1d2c),
                  ),
                  
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.9,
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
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
