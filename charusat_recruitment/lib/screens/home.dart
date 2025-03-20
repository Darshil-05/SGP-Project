import 'dart:math' as math;
import 'package:charusat_recruitment/screens/screens_after_auth/company/company.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/home/notification.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/profile/studentprofile.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/home/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'screens_after_auth/home/home_after_auth.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/home/customtabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charusat_recruitment/Providers/menu_provider.dart'; // import the MenuProvider

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController? _animationController;
  late Animation<double> _sidebarAnim;
  bool _prevMenuState = false;

  Widget _tabBody = Container(color: Colors.amber);

  final List<Widget> _screen = [
    const HomeApp(),
    const CompanyPage(),
    NotificationPage(),
    ProfilePage()
  ];

  final springDesc =
      const SpringDescription(mass: 0.1, stiffness: 40, damping: 5);

  void handleMenuStateChange(bool isOpen) {
    // Only trigger animation if menu state actually changed
    if (_prevMenuState != isOpen) {
      _prevMenuState = isOpen;

      // Trigger the animation based on the menu state
      if (isOpen) {
        final springAnim = SpringSimulation(springDesc, 0, 1, 0);
        _animationController?.animateWith(springAnim);
      } else {
        _animationController?.reverse();
      }

      // Toggle the system UI overlay style based on menu state
      SystemChrome.setSystemUIOverlayStyle(
          isOpen ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.linear));

    _tabBody = _screen.first;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      // Use Consumer to listen for changes in MenuProvider
      builder: (context, menuProvider, child) {
        // Update _tabBody when selectedTab changes
        _tabBody = _screen[menuProvider.selectedTab];

        // Handle menu state changes
        handleMenuStateChange(menuProvider.isMenuOpen);

        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              Positioned(
                child: Container(
                  color: const Color.fromARGB(255, 17, 19, 33),
                ),
              ),
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _sidebarAnim,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(
                            ((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                        ..translate((1 - _sidebarAnim.value) * -300),
                      child: child,
                    );
                  },
                  child: FadeTransition(
                    opacity: _sidebarAnim,
                    child: const SideMenu(),
                  ),
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
                            ..rotateY(
                                (_sidebarAnim.value * 30) * math.pi / 180),
                          child: child!,
                        ),
                      ),
                    );
                  },
                  child: _tabBody,
                ),
              ),
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _sidebarAnim,
                  builder: (context, child) {
                    return SafeArea(
                      child: Row(
                        children: [
                          SizedBox(width: _sidebarAnim.value * 216),
                          child!,
                        ],
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      menuProvider.toggleMenu();
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
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: const Color(0xff0f1d2c).withOpacity(0.2),
                            offset: const Offset(5, 0),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        menuProvider.isMenuOpen
                            ? Icons.menu_open_rounded
                            : Icons.menu,
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
              builder: (context, child) {
                return Transform.translate(
                    offset: Offset(0, (_sidebarAnim.value * 300)),
                    child: child!);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, -1),
                      blurRadius: 10,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(bottom: 25),
                child: CustomTabBar(
                  onTabChange: (tabIndex) {
                    // Update both the local state and the provider
                    menuProvider.setSelectedTab(tabIndex);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
