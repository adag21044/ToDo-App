import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/appicon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tasks',
          importance: NotificationImportance.High,
          channelShowBadge: true,
          enableLights: true,
          enableVibration: true,
        ),
      ],
    );
  }

  Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
  required Map<String, String> payload,
}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: title,
      body: body,
      payload: payload,
    ),
    schedule: NotificationCalendar(
      year: scheduledDate.year,
      month: scheduledDate.month,
      day: scheduledDate.day,
      hour: scheduledDate.hour,
      minute: scheduledDate.minute,
      second: 0,
      millisecond: 0,
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      repeats: false, // Tekrarlama gerekmiyorsa false yapın
    ),
  );
}

}
