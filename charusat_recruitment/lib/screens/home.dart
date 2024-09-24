import 'dart:ffi';
import 'dart:math' as math;
import 'package:charusat_recruitment/screens/screens_after_auth/company/company.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/notification.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/profile.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'screens_after_auth/home_after_auth.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/customtabbar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController? _animationController;
  late Animation<double> _sidebarAnim;

  bool _menubtn = false;

  Widget _tabBody = Container(color: Colors.amber);

  final List<Widget> _screen = [
    const HomeApp(),
    const CompanyPage(),
    NotificationPage(),
    ProfilePage()
  ];
  final springDesc =
      const SpringDescription(mass: 0.1, stiffness: 40, damping: 5);
  void onMenupress() {
    if (_menubtn) {
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _animationController?.animateWith(springAnim);
    } else {
      _animationController?.reverse();
    }
    SystemChrome.setSystemUIOverlayStyle(_menubtn ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
  }
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.linear));

    _tabBody = _screen.first;
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned(
              child: Container(
            color: const Color.fromARGB(255, 17, 19, 33),
          )),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                      ..translate((1 - _sidebarAnim.value) * -300),
                    child: child);
              },
              child: FadeTransition(
                opacity: _sidebarAnim,
                child: const SideMenu()),
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 - _sidebarAnim.value * 0.1,
                  child: Transform.translate(
                      offset: Offset(_sidebarAnim.value * 265, 0),
                      child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
                          child: child!)),
                );
              },
              child: _tabBody,
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context , child) {
                return SafeArea(
                  child: Row(
                    children: [
                      SizedBox(width: _sidebarAnim.value * 216,),
                      child!,
                    ],
                  )
                );
              }
              ,child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _menubtn = !_menubtn; // Toggle the side menu visibility
                      });
                      onMenupress();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xff0f1d2c).withOpacity(0.2),
                                offset: const Offset(0, 5),
                                blurRadius: 5),
                            BoxShadow(
                                color: const Color(0xff0f1d2c).withOpacity(0.2),
                                offset: const Offset(5, 0),
                                blurRadius: 5)
                          ]),
                      child: Icon(
                        _menubtn ? Icons.menu_open_rounded : Icons.menu  ,
                        size: 30,
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _sidebarAnim,
          builder: (context , child) {
            return Transform.translate(
              offset: Offset(0,(_sidebarAnim.value * 300)),child: child!);
          }
          ,
          child:Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    offset: const Offset(0, -1), // Shadow offset
                    blurRadius: 10, // Shadow blur radius
                    spreadRadius: 10, // Shadow spread radius
                  ),
                ],
              ),
              padding: const EdgeInsets.only(bottom: 25),
              child: CustomTabBar(onTabChange: (tabIndex) {
                setState(() {
                  _tabBody = _screen[tabIndex];
                });
              }),
            ) ,
        ),
      ),
    );
  }
}
