import 'package:charusat_recruitment/Providers/theme_provider.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/customtabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hey"),
        ),
        body: Text("Hello"),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: CustomTabBar(),
        ),
        );
  }
}
