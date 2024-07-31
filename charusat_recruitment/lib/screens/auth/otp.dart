import 'dart:async';
import 'package:flutter/material.dart';
import 'registerheader.dart'; // Ensure the correct import for RegisterHeader

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());

  late Timer _timer;
  int _start = 30;
  bool _isButtonDisabled = true;
  bool _showTimer = true;

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

  void _submitOtp() {
    // Collect OTP from controllers and process verification
    String otp = _otpControllers.map((controller) => controller.text).join();
    print('OTP entered: $otp');
    // Add OTP verification logic here
  }

  void _resendOtp() {
    setState(() {
      _start = 30; // Restart the timer with 30 seconds
      _isButtonDisabled = true;
      _showTimer = true;
    });
    _startTimer();
    print('Resend OTP');
    // Add resend OTP logic here
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),

          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,

          buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) {
            return null; // Hides the counter
          },
          onChanged: (value) {
            if (value.length == 1 && index < 3) {
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
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) => _buildOtpField(index)),
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
                child: const Center(
                  child: Text(
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
            GestureDetector(
              onTap: () {
                // Navigate back to login or registration page
                Navigator.pop(context);
              },
              child: const Text(
                "Back to Login",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff0f1d2c),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
