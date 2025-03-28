import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, String>> unreadNotifications = [
    {
      'icon': Icons.security_outlined.codePoint.toString(),
      'title': 'Your Security Password has been successfully changed.',
      'time': '10 minutes ago'
    },
    {
      'icon': Icons.add_circle_outline.codePoint.toString(),
      'title': '32+ 3D icons have been added in the AI category.',
      'time': 'Today 7:12 am'
    },
  ];

  // Sample read notifications
  List<Map<String, String>> readNotifications = [
    {
      'icon': Icons.system_update_outlined.codePoint.toString(),
      'title': 'A new version of the software has changed the UI/UX.',
      'time': 'Thursday 2:20 pm'
    },
    {
      'icon': Icons.emoji_objects_outlined.codePoint.toString(),
      'title':
          '120+ animated icons have been added in the technology category.',
      'time': 'Wednesday 9:31 pm'
    },
    {
      'icon': Icons.build_circle_outlined.codePoint.toString(),
      'title': 'Your icon request has been completed and will be ready soon.',
      'time': 'Friday 11:39 pm'
    },
  ];

  // Widget to build the section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Widget to build the notification list
  Widget _buildNotificationList(List<Map<String, String>> notifications,
      {bool isUnread = false}) {
    return Column(
      children: notifications.map((notification) {
        return isUnread
            ? Dismissible(
                key: Key(notification['title']!),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    // Move the dismissed notification to read list
                    readNotifications.add(notification);
                    unreadNotifications.remove(notification);
                  });
                },
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.check, color: Colors.white),
                ),
                child: _buildNotificationCard(notification),
              )
            : _buildNotificationCard(notification);
      }).toList(),
    );
  }

  // Widget to build each notification card
  Widget _buildNotificationCard(Map<String, String> notification) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 2),
      child: Card(
        color: Colors.white60.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Icon
              Icon(
                IconData(int.parse(notification['icon']!),
                    fontFamily: 'MaterialIcons'),
                size: 40,
                color: Colors.black,
              ),
              SizedBox(width: 15),
              // Notification details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notification title
                    Text(
                      notification['title']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    // Notification time
                    Text(
                      notification['time']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    print("inside a notifications");

    // TODO: implement initState
    super.initState();
  }

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
                "Unread",
                style: TextStyle(fontSize: 20, fontFamily: "pop"),
              ),
            ),
            _buildNotificationList(unreadNotifications, isUnread: true),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Read",
                style: TextStyle(fontSize: 20, fontFamily: "pop"),
              ),
            ),
            _buildNotificationList(readNotifications, isUnread: false),
          ],
        ),
      ),
    );
  }
}
