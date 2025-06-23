import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid && !kIsWeb) {
      final status = await Permission.notification.request();
      debugPrint("通知权限状态: $status");
    }
  }

  static Future<void> requestExactAlarmPermission() async {
    try {
      final status = await Permission.scheduleExactAlarm.request();
      debugPrint('🔒 精确闹钟权限状态: ${status.isGranted ? "已授予" : "未授予"}');

      if (!status.isGranted) {
        debugPrint('⚠️ 需要精确闹钟权限才能显示定时通知');
      }
    } catch (e) {
      debugPrint('❌ 权限请求失败: $e');
    }
  }
}
