import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static void initialize() {
    AwesomeNotifications().initialize(
      'resource://drawable/ic_notification',
      [
        NotificationChannel(
          channelKey: 'weather_channel',
          channelName: 'Weather Notifications',
          channelDescription: 'Notifications for weather updates',
          defaultColor: const Color(0xff181C14),
          ledColor: Colors.white,
          icon: 'resource://drawable/ic_notification',
        ),
      ],
    );
  }

  static Future<void> requestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Request notification permissions
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static void scheduleDailyWeatherCheck({
    required String title,
    required String body,
  }) {
    DateTime now = DateTime.now();
    DateTime scheduledTime =
        DateTime(now.year, now.month, now.day, 7, 0); // Set to 7 AM today

    // If the scheduled time has already passed for today, set it for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'weather_channel',
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        year: scheduledTime.year,
        month: scheduledTime.month,
        day: scheduledTime.day,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: scheduledTime.second,
        repeats: true, // Set to true to repeat daily
      ),
    );

    print("Scheduled notification for $title at: $scheduledTime");
  }

// static void sendTestNotification() {
//   AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 3,
//       channelKey: 'weather_channel',
//       title: 'Test Notification',
//       body: 'This is a test notification triggered by button press.',
//     ),
//   );
//   print("Test notification sent.");
// }
}
