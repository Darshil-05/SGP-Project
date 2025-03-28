import 'dart:async';
import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';
import 'package:flutter/material.dart';
import '../auth/registerheader.dart';

class OtpPage extends StatefulWidget {
  final String password , name ;
  const OtpPage({super.key , required this.name , required this.password});

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
    print("Inside a OTP Screen");

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

  void verifyOtpCode() async {
    AuthenticationService authService = AuthenticationService();
    String otp = _otpControllers.map((controller) => controller.text).join();
    debugPrint("OTP verification started : $email , $otp");
    bool success = await authService.verifyOtp(widget.name , email,  widget.password , otp);
    role = determineEmailType(email);
    if (success) {
      debugPrint("OTP Verified Successfully");
      if (mounted) {
        print("role : $role");
        if (role != "faculty") {
          print("role is faculty");
          Navigator.of(context).pushReplacementNamed('/studentDetails');
        } else {
          Navigator.of(context).pushReplacementNamed('/facultyDetails');
        }
      }
    } else {
      debugPrint("OTP Verification Failed");
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
    debugPrint('Resend OTP');
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
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
              onTap: verifyOtpCode,
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
