import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // Request permission for iOS and Android
    await _firebaseMessaging.requestPermission();
    
    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token"); // Store this token in your backend

    // Handle notifications when app is in different states
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground Notification: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔄 User tapped the notification: ${message.notification?.title}");
      // Handle navigation when a user taps the notification
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Show notification when app is in foreground
  void _showLocalNotification(RemoteMessage message) async {
    var androidDetails = const AndroidNotificationDetails(
      'channel_id', 'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);
    await _localNotifications.show(
      0, 
      message.notification?.title, 
      message.notification?.body, 
      notificationDetails,
    );
  }
}

// Background message handler (when app is terminated or in the background)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📲 Background Notification: ${message.notification?.title}");
}
