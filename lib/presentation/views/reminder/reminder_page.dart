import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../resources/assets.dart';
import '../../../resources/strings.dart';
import 'reminder_completed_page.dart';
import '../../../services/permission_service.dart';
import '../../view_models/reminder_view_model.dart';
import 'reminder_input_sheet.dart';
import '../../widgets/reminder_item.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  void _showAddReminderSheet(BuildContext context) async {
    // ✅ 请求通知权限（Android 13+）
    await PermissionService.requestNotificationPermission();
    await PermissionService.requestExactAlarmPermission();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReminderInputSheet(
        onSubmit: (text, duration) {
          // ✅ 通过 ViewModel 添加提醒
          context.read<ReminderViewModel>().addReminder(text, duration);
        },
      ),
    );
    // NotificationService.testQuickNotification();
    // NotificationService.showImmediateNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.reminderTitle),
        actions: [
          IconButton(
            icon: Image.asset(Assets.reminderImgMenu, width: 24, height: 24),
            onPressed: () {
              // TODO: 跳转到已完成页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReminderCompletedPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: const _ReminderBody(),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        onPressed: () => _showAddReminderSheet(context),
        child: Image.asset(Assets.commonImgAdd, width: 24, height: 24),
      ),
    );
  }
}

class _ReminderBody extends StatelessWidget {
  const _ReminderBody();

  @override
  Widget build(BuildContext context) {
    final reminders = context.watch<ReminderViewModel>().reminders;

    // ✅ 添加 return，修复无返回的 bug
    return reminders.isEmpty
        ? const Center(
            child: Text(
              Strings.reminderEmptyContent,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green),
            ),
          )
        : ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return ReminderItem(reminder: reminder);
            },
          );
  }
}
