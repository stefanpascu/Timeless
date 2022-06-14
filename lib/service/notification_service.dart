import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    // the initialization settings are initialized after they are set
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
      int id, String title, String body, DateTime time) async { //
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.UTC)
          .add(Duration( // seconds: 1
          days: time.day - DateTime.now().day,
          hours: time.hour - DateTime.now().hour,
          minutes: time.minute - DateTime.now().minute,
          seconds: time.second - DateTime.now().second
      )), 

      const NotificationDetails(
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "Timeless",
            importance: Importance.max,
            priority: Priority.max),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

}
