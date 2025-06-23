import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart'; // 添加权限处理

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("🔔 通知点击: ${response.payload}");
      },
    );

    // 创建通知通道
    await _createNotificationChannel();

  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel',
      '提醒通知',
      description: '定时提醒事项通知',
      importance: Importance.max,
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      await android.createNotificationChannel(channel);
      debugPrint('✅ 已创建通知通道 reminder_channel');
    } else {
      debugPrint('❌ Android 通道创建失败');
    }
  }

  /// 显示定时通知
  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final androidDetails = const AndroidNotificationDetails(
      'reminder_channel',
      '提醒通知',
      channelDescription: '定时提醒事项通知',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    // 转换为带时区的时间
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      debugPrint("✅ 通知已成功调度: ID $id, 时间: $scheduledTime");
    } catch (e) {
      debugPrint("❌ 通知调度失败: $e");
    }

    // 打印已注册的通知
    await _printPendingNotifications();
  }

  /// 快速测试 - 60秒后弹出通知
  static Future<void> testQuickNotification() async {
    final scheduledTime = DateTime.now().add(const Duration(seconds: 60));

    await showScheduledNotification(
      id: 999,
      title: '⏱️ 60秒测试通知',
      body: '这是一条60秒后弹出的通知',
      scheduledTime: scheduledTime,
      payload: 'test_payload',
    );
  }

  /// 立即通知
  static Future<void> showImmediateNotification() async {
    await _plugin.show(
      1000,
      '⏰ 即时测试通知',
      '这是一条立刻弹出的通知',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          '提醒通知',
          channelDescription: '用于测试即时通知',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'immediate_test',
    );
  }

  static Future<void> _printPendingNotifications() async {
    try {
      final pending = await _plugin.pendingNotificationRequests();
      debugPrint("📋 当前已注册通知数量: ${pending.length}");

      if (pending.isEmpty) {
        debugPrint("ℹ️ 没有待处理的通知");
        return;
      }

      for (var p in pending) {
        debugPrint("""
🔔 通知详情:
  ID: ${p.id}
  标题: ${p.title}
  内容: ${p.body}
  触发时间: ${p.payload}
""");
      }
    } catch (e) {
      debugPrint("❌ 获取待处理通知失败: $e");
    }
  }

  /// 取消某个通知
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
    debugPrint("🗑️ 已取消通知 ID: $id");
  }

  /// 取消所有通知
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint("🗑️ 已取消所有通知");
  }
}
