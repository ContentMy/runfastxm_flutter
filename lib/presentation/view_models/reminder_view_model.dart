import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/reminder.dart';
import '../../../data/repositories_impl/reminder_repository_impl.dart';
import '../../../services/notification_service.dart';

import 'dart:async';

class ReminderViewModel extends ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();
  final List<Reminder> _reminders = [];
  Timer? _timer;

  List<Reminder> get reminders =>
      List.unmodifiable(_reminders.where((r) => !r.remindCompleteStatus));

  List<Reminder> get completedReminders =>
      List.unmodifiable(_reminders.where((r) => r.remindCompleteStatus));

  ReminderViewModel() {
    loadReminders();
    _startAutoExpireCheck();  // 加入自动检查
  }

  void loadReminders() {
    _reminders.clear();
    _reminders.addAll(_repository.getAll());
    notifyListeners();
  }

  // 定时检查提醒是否完成
  void _startAutoExpireCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final now = DateTime.now();
      bool updated = false;

      for (int i = 0; i < _reminders.length; i++) {
        final r = _reminders[i];

        // 如果还未完成并且已经到时间
        if (!r.remindCompleteStatus && r.endDateTime.isBefore(now)) {
          final updatedReminder = Reminder(
            id: r.id,
            remindImg: r.remindImg,
            remindTitle: r.remindTitle,
            remindContent: r.remindContent,
            remindTime: r.remindTime,
            remindStartTime: r.remindStartTime,
            remindEndTime: r.remindEndTime,
            remindCompleteStatus: true, // ✅ 标记为已完成
          );

          await _repository.update(updatedReminder); // 你需要实现这个方法
          _reminders[i] = updatedReminder;
          updated = true;
        }
      }

      if (updated) notifyListeners(); // 通知 UI 刷新
    });
  }


  Future<void> addReminder(String content, Duration duration) async {
    final id = const Uuid().v4();
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    final durationMillis = duration.inMilliseconds;

    final reminder = Reminder(
      id: id,
      remindImg: "ic_reminder",            // 默认提醒图标
      remindTitle: content,                 // 标题就是 content
      remindContent: content,               // 详情内容暂时同标题
      remindTime: durationMillis,           // 间隔时间，毫秒
      remindStartTime: nowMillis,           // 创建时间戳，毫秒
      remindEndTime: nowMillis + durationMillis,  // 结束时间戳
      remindCompleteStatus: false,          // 初始状态未完成
    );

    await _repository.add(reminder);
    _reminders.add(reminder);
    notifyListeners();

    final scheduledTime = DateTime.now().add(duration);
    debugPrint("⏰ 即将调度通知时间: $scheduledTime");

    await NotificationService.showScheduledNotification(
      id: id.hashCode,
      title: "提醒事项",
      body: content,
      scheduledTime: scheduledTime,
    );
  }

  Future<void> removeReminder(Reminder reminder) async {
    await _repository.remove(reminder.id);
    _reminders.removeWhere((r) => r.id == reminder.id);
    notifyListeners();

    await NotificationService.cancel(reminder.id.hashCode);
  }

  Future<void> clearAll() async {
    await _repository.clear();
    _reminders.clear();
    notifyListeners();

    await NotificationService.cancelAll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void addReminderFromCompleted(Reminder newReminder) {

  }
}

