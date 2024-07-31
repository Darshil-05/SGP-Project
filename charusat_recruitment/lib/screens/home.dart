import 'package:charusat_recruitment/Providers/theme_provider.dart';
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
    final themechanger = Provider.of<Themechange>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Hey"),
        ),
        body: Column(
          children: [
                  RadioListTile<ThemeMode>(
              title: Text('dark Theme'),
                value: ThemeMode.dark,
                 groupValue: themechanger.themeMode,
                  onChanged: themechanger.setTheme
                  ),
                   RadioListTile<ThemeMode>(
              title:  Text('Light Theme'),
                value: ThemeMode.light,
                 groupValue: themechanger.themeMode,
                  onChanged: themechanger.setTheme
                  ),
                  RadioListTile<ThemeMode>(
              title:  Text('system Theme'),
                value: ThemeMode.system,
                 groupValue: themechanger.themeMode,
                  onChanged: themechanger.setTheme
                  ),
                  Text("Hello World" , style: TextStyle(fontFamily: "normalfont"),),
                  Text("Hello World" , style: TextStyle(fontFamily: "boldfont" , fontSize: 30),),
                  Text("Hello World" , style: TextStyle(fontFamily: "extraboldfont"),),
                  Text("Hello World" , style: TextStyle(fontFamily: "regularfont",fontSize: 30 , fontWeight: FontWeight.w200),),
                  Text("Hello World" , style: TextStyle(fontFamily: "mediumfont", fontSize: 30),),
          ],
        ));
  }
}
