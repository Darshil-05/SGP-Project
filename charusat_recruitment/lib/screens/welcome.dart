import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color(0xff0f1d2c),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: -10,
                      offset: const Offset(5, 5),
                      blurRadius: 20)
                ]),
            height: height * 0.63,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    "assets/images/charusaticon.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(bottom: 50, left: 25),
                  child: const Text(
                    "Connecting Talent with Opportunities",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        wordSpacing: 5,
                        fontWeight: FontWeight.w100,
                        letterSpacing: 2),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.09,
          ),
          Container(
            height: height * 0.06,
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
                      blurRadius: 20)
                ]),
            child: const Center(
              child: Text(
                "Sign in",
                style: TextStyle(
                    color: Colors.white, fontSize: 28, letterSpacing: 4),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.04,
          ),
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
                style: TextStyle(fontSize: 18 , decoration: TextDecoration.underline),
              )),
            ],
          )
        ],
      ),
    );
  }
}
