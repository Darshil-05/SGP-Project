import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Define a list of icons for the bottom navigation
List<IconData> bottomNavigationItems = [
  Icons.dashboard_rounded,
  Icons.analytics_rounded,
  Icons.notifications_rounded,
  Icons.person_rounded,
];

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  // Variable to track the selected index
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 11),
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xff0f1d2c),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            bottomNavigationItems.length,
            (index) {
              bool isSelected = index == _selectedIndex;
              return Expanded(
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: isSelected ? 1.0 : 0.5,
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          bottomNavigationItems[index],
                          color: Colors.white,
                          size: isSelected ? 30 : 28,
                        ),
                      ),
                      SizedBox(height: 4),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: 2,
                        width: isSelected ? 30 : 0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
