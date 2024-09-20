import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 25,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 80.0),
              child: Text(
                "Notifications",
                style: TextStyle(fontSize: 25, fontFamily: "pop"),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "New",
                style: TextStyle(fontSize: 20, fontFamily: "pop"),
              ),
            ),

            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(5),
              child: const Column(
                children: [
                  Card(
                    color: Color.fromARGB(255, 238, 243, 255),
                    child: ListTile(
                      title: Text(
                        "Form submision is open ",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "TCS Tech",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 238, 243, 255),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 238, 243, 255),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 238, 243, 255),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 238, 243, 255),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 238, 243, 255),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Recent",
                style: TextStyle(fontSize: 20, fontFamily: "pop"),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: const Column(
                children: [
                  Card(
                    color: Color.fromARGB(255, 229, 230, 231),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 229, 230, 231),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 229, 230, 231),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 229, 230, 231),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 229, 230, 231),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                  Card(
                    color: Color.fromARGB(255, 229, 230, 231),
                    child: ListTile(
                      title: Text(
                        "Tata Technologies",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "Ahemdabad , surat",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Listen to changes in PieChartProvider
          ],
        ),
      ),
    );
  }
}
