import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charusat_recruitment/Providers/menu_provider.dart';

// Define a list of icons for the bottom navigation
List<IconData> bottomNavigationItems = [
  Icons.dashboard_rounded,
  Icons.analytics_rounded,
  Icons.notifications_rounded,
  Icons.person_rounded,
];

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key, required this.onTabChange});
  final Function(int tabIndex) onTabChange;
  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  onTabpress(int index) {
    widget.onTabChange(index);
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final _selectedIndex =
        menuProvider.selectedTab; // Get selected tab from provider

    return SafeArea(
      child: Container(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 11),
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xff0f1d2c),
            borderRadius: BorderRadius.all(Radius.circular(25)),
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
                      menuProvider.setSelectedTab(index);
                      onTabpress(index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.5,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            bottomNavigationItems[index],
                            color: Colors.white,
                            size: isSelected ? 30 : 28,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
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
      ),
    );
  }
}
