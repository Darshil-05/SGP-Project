import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final String title; // Add this parameter

  const LoginHeader({super.key, required this.title}); // Initialize the parameter

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 325,
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        color: Color(0xff0f1d2c),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -250,
            left: -300,
            child: Container(
              height: 600,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -200,
            left: -250,
            child: Container(
              height: 600,
              width: 600,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 20,
            child: Text(
              title, // Use the parameter
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Positioned(
            top: 205,
            left: 20,
            child: Text(
              "Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
