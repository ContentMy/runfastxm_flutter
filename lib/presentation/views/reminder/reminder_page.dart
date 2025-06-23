import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        title: const Text('提醒列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist_rtl),
            onPressed: () {
              // TODO: 跳转到已完成页面
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReminderCompletedPage()),
              );
            },
          ),
        ],
      ),
      body: const _ReminderBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderSheet(context),
        child: const Icon(Icons.add),
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
      child: Text('再也不怕忘掉啦~\n点击 "+" 添加提醒吧！',
          textAlign: TextAlign.center),
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
