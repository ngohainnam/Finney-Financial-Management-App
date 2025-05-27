import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
    InitializationSettings(android: androidSettings);

    await plugin.initialize(initializationSettings);

    // Android 13+ exact alarm permission
    await plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    log('🔔 NotificationService initialized');
  }

  /// Schedule a daily budget reminder
  static Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    log('🕒 Scheduling reminder for ${scheduledTime.toLocal()} (${scheduledTime.timeZoneName})');

    try {
      await plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel_id',
            'Daily Reminders',
            channelDescription: 'Reminder for daily budget check',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
            visibility: NotificationVisibility.public,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      log('Notification scheduled successfully at ${scheduledTime.toLocal()}');
    } catch (e, stack) {
      log('Failed to schedule notification: $e', stackTrace: stack);
    }
  }

  /// Show reminder at startup once per day
  static Future<void> showStartupReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'startup_reminder_channel_id',
      'Startup Reminder',
      channelDescription: 'Daily budget tips or nudges at app launch',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await plugin.show(
      777, // ID
      "বাজেট স্মরণ করিয়ে দিচ্ছি",
      "বাজেট রিমাইন্ডার সেট করতে ভুলবেন না! সময়মতো খরচ লিখে রাখুন।",
      details,
    );

    log('📣 Startup notification shown');
  }
}
