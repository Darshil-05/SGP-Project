import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<String?> initNotifications() async {
    // Request permission for iOS and Android
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token"); // Store this token in your backend

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground Notification: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // Handle notification tap (when app is in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔄 User tapped the notification: ${message.notification?.title}");
      // Handle navigation when a user taps the notification
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    return token;
  }

  // Create a notification channel (Required for Android 8+)
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id', // Must match with AndroidNotificationDetails
      'General Notifications', // Channel name
      description: 'This channel is used for general notifications.',
      importance: Importance.high,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show notification when app is in foreground
  void _showLocalNotification(RemoteMessage message) async {
    var androidDetails = const AndroidNotificationDetails(
      'channel_id', // Must match created channel
      'General Notifications',
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

  // Logout handling method
  Future<void> handleLogout() async {
    try {
      // Unsubscribe from all topics (if you've subscribed to any)
      // Uncomment and modify if you use topics
      // await _firebaseMessaging.unsubscribeFromTopic('your_topic');

      // Delete the current FCM token
      await _firebaseMessaging.deleteToken();

      // Remove notification listeners
      FirebaseMessaging.onMessage.listen((event) {}).cancel();
      FirebaseMessaging.onMessageOpenedApp.listen((event) {}).cancel();

      print('Notification services reset on logout');
    } catch (e) {
      print('Error during notification logout handling: $e');
    }
  }
}

// Background message handler (when app is terminated or in the background)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📲 Background Notification: ${message.notification?.title}");
}