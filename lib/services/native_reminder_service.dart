import 'package:flutter/services.dart';

class NativeReminderService {
  static const MethodChannel _channel = MethodChannel('reminder_channel');

  static Future<void> scheduleReminder({
    required String id,
    required String title,
    required String content,
    required int delayMillis,
  }) async {
    await _channel.invokeMethod('scheduleReminder', {
      'id': id,
      'title': title,
      'content': content,
      'delayMillis': delayMillis,
    });
  }

  static Future<void> cancelReminder(String id) async {
    await _channel.invokeMethod('cancelReminder', {
      'id': id,
    });
  }

  static Future<void> openNotificationSettings() async {
    await _channel.invokeMethod('openNotificationSettings');
  }
}
