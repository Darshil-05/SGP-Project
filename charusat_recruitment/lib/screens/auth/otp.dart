import 'dart:async';
import 'dart:convert';
import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/screens/auth/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/registerheader.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  late Timer _timer;
  int _start = 30;
  bool _isButtonDisabled = true;
  bool _showTimer = true;
  final bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _isButtonDisabled = true;
    _showTimer = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
          _isButtonDisabled = false;
          _showTimer = false; // Hide the timer
          _start = 60; // Set the timer to 60 seconds for the next interval
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _submitOtp() async {
  // Collect OTP from controllers
  String otp = _otpControllers.map((controller) => controller.text).join();

  
  // Prepare the data to send
  Map<String, String> data = {
    "email": email, 
    "otp": otp,
  };

  try {
    // Send OTP to the server
    final response = await http.post(
      Uri.parse("$serverurl/verify-otp"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Assuming success response
      print('OTP verification successful');
      // After successful OTP verification, clear all previous pages from the stack and push the home page
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const StudentDetailsPage()), // Replace with your home page
          (Route<dynamic> route) => false, // This clears all previous routes
        );
      }
    } else {
      // If verification fails, handle error
      final error = jsonDecode(response.body)['error'] ?? 'Verification failed';
      _showErrorDialog(context, error);
    }
  } catch (e) {
    // Handle any error in communication or unexpected issues
    _showErrorDialog(context, 'An error occurred. Please try again.');
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

  void _resendOtp() {
    setState(() {
      _start = 60;
      _isButtonDisabled = true;
      _showTimer = true;
    });
    _startTimer();
    print('Resend OTP');
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  Widget _buildOtpField(int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextFormField(
          controller: _otpControllers[index],
          focusNode: _focusNodes[index],
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff0f1d2c)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff0f1d2c)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
          ),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) {
            return null; // Hides the counter
          },
          onChanged: (value) {
            if (value.length == 1 && index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
            if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
          cursorColor:
              const Color(0xff0f1d2c), // Optional: Change the cursor color
        ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const RegisterHeader(
              title: "Verification",
              subtitle: "Enter OTP received in email",
              navigator: true,
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) => _buildOtpField(index)),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _isButtonDisabled ? null : _resendOtp,
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontSize: 15,
                      color: _isButtonDisabled
                          ? Colors.grey
                          : const Color(0xff0f1d2c),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Opacity(
                  opacity: _showTimer ? 1.0 : 0.0,
                  child: Text(
                    '$_start s',
                    style:
                        const TextStyle(fontSize: 15, color: Color(0xff0f1d2c)),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            GestureDetector(
              onTap: _submitOtp,
              child: Container(
                height: screenHeight * 0.07,
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xff0f1d2c),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: -3,
                      offset: const Offset(3, 3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator() // Show progress indicator while loading
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            letterSpacing: 3,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
