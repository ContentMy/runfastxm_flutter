import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/reminder.dart';
import '../../data/repositories_impl/reminder_repository_impl.dart';
import '../../../services/notification_service.dart';

import 'dart:async';

import '../../services/native_reminder_service.dart';

class ReminderViewModel extends ChangeNotifier {
  final ReminderRepository _repository;
  final List<Reminder> _reminders = [];
  Timer? _timer;

  ReminderViewModel(this._repository) {
    loadReminders();
    _startAutoExpireCheck();
  }

  List<Reminder> get reminders =>
      List.unmodifiable(_reminders.where((r) => !r.remindCompleteStatus));

  List<Reminder> get completedReminders =>
      List.unmodifiable(_reminders.where((r) => r.remindCompleteStatus));

  void loadReminders() {
    _reminders.clear();
    _reminders.addAll(_repository.getAll());
    notifyListeners();
  }

  void _startAutoExpireCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final now = DateTime.now();
      bool updated = false;

      for (int i = 0; i < _reminders.length; i++) {
        final r = _reminders[i];

        if (!r.remindCompleteStatus && r.endDateTime.isBefore(now)) {
          final updatedReminder = Reminder(
            id: r.id,
            remindImg: r.remindImg,
            remindTitle: r.remindTitle,
            remindContent: r.remindContent,
            remindTime: r.remindTime,
            remindStartTime: r.remindStartTime,
            remindEndTime: r.remindEndTime,
            remindCompleteStatus: true,
          );

          await _repository.update(updatedReminder);
          _reminders[i] = updatedReminder;
          updated = true;
        }
      }

      if (updated) notifyListeners();
    });
  }

  Future<void> addReminder(String content, Duration duration) async {
    // 调试时写死为 1 分钟
    duration = const Duration(minutes: 1);
    final id = const Uuid().v4();
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    final durationMillis = duration.inMilliseconds;

    final reminder = Reminder(
      id: id,
      remindImg: "ic_reminder",
      remindTitle: content,
      remindContent: content,
      remindTime: durationMillis,
      remindStartTime: nowMillis,
      remindEndTime: nowMillis + durationMillis,
      remindCompleteStatus: false,
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
    //
    // await NativeReminderService.scheduleReminder(
    //   id: id,
    //   title: "提醒事项原生",
    //   content: content,
    //   delayMillis: duration.inMilliseconds,
    // );
    //
    // debugPrint("⏰ 已通过原生调度提醒");
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

  Future<void> addReminderFromCompleted(Reminder newReminder) async {
    // 替换旧数据：找到原 Reminder 并移除
    _reminders.removeWhere((r) => r.id == newReminder.id);

    // 保存新 Reminder
    await _repository.add(newReminder);
    _reminders.add(newReminder);
    notifyListeners();

    // 重新调度通知
    final scheduledTime = DateTime.now().add(
      Duration(milliseconds: newReminder.remindTime),
    );
    debugPrint("⏰ 重新调度提醒时间: $scheduledTime");

    await NotificationService.showScheduledNotification(
      id: newReminder.id.hashCode,
      title: "提醒事项",
      body: newReminder.remindTitle,
      scheduledTime: scheduledTime,
    );
  }
}
