import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  final String title, subtitle; // Add this parameter
  final bool? navigator;
  const RegisterHeader(
      {super.key, required this.title, required this.subtitle, this.navigator});
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
            top: 60,
            left: 15,
            child: Visibility(
              visible: navigator ?? false,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white,size: 25,),
                ),
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
          Positioned(
            top: 220,
            left: 20,
            child: Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 25,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
