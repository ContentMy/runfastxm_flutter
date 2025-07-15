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

  static Future<bool> isNotificationEnabled() async {
    return await _channel.invokeMethod<bool>('isNotificationEnabled') ?? false;
  }

  static Future<void> openNotificationSettings() async {
    await _channel.invokeMethod('openNotificationSettings');
  }

  static Future<bool> isAutoStartEnabled() async {
    return await _channel.invokeMethod<bool>('isAutoStartEnabled') ?? false;
  }

  static Future<void> openAutoStartSettings() async {
    await _channel.invokeMethod('openAutoStartSettings');
  }
}
