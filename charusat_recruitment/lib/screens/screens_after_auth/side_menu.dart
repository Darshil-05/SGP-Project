import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // State variable to manage the CupertinoSwitch
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 17, 19, 33),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      constraints: const BoxConstraints(maxWidth: 288),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.person_outlined),
                ),
                const SizedBox(width: 10),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Darshil Patel",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    Text(
                      "Flutter developer",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                Divider(thickness: 0.5),
                ListTile(
                  leading: Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Setting',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                Divider(thickness: 0.5),
                ListTile(
                  leading: Icon(
                    Icons.announcement_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Announcement',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                Divider(thickness: 0.5),
                ListTile(
                  leading: Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Company drive',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                Divider(thickness: 0.5),
              ],
            ),
          ),
          // CupertinoSwitch placed under "Company drive"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Mode',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                CupertinoSwitch(
                  value: _isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    // Here you can add the logic to change the theme
                  },
                  activeColor: Colors.blue, // Color when the switch is active
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
