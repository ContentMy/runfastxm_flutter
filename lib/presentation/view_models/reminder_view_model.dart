import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/reminder.dart';
import '../../data/repositories_impl/reminder_repository_impl.dart';
import '../../../services/notification_service.dart';

import 'dart:async';

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
    // 可选实现
  }
}
