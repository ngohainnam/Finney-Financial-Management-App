import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();


  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: androidSettings);
    await plugin.initialize(settings);
    tz.initializeTimeZones();
  }


  static Future<void> requestPermission() async {
    final granted = await plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    print("🔔 Notification permission granted: $granted");
  }


  static Future<void> showTestNotification() async {
    print("🔔 showTestNotification() called");

    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'For testing local reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    try {
      await plugin.zonedSchedule(
        0,
        '🔔 Budget Reminder',
        'This is a test notification!',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        platformDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, // Avoids exact alarm permission
      );
      print("✅ Notification scheduled.");
    } catch (e) {
      print("❌ Error scheduling test notification: $e");
    }
  }


  static Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime time,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_budget_reminder',
      'Daily Budget Reminder',
      channelDescription: 'Daily reminder to check your budget',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    try {
      await plugin.zonedSchedule(
        id,
        title,
        body,
        time,
        platformDetails,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time, // daily repeat
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, // No exact alarm needed
      );
      print("✅ Daily reminder scheduled for $time");
    } catch (e) {
      print("❌ Error scheduling daily reminder: $e");
    }
  }


  static Future<void> cancelReminder(int id) async {
    await plugin.cancel(id);
    print("🔕 Reminder with ID $id cancelled");
  }
}
