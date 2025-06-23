import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/reminder.dart';
import '../../view_models/reminder_view_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ReminderCompletedPage extends StatelessWidget {
  const ReminderCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final completedReminders =
        context.watch<ReminderViewModel>().completedReminders;

    return Scaffold(
      appBar: AppBar(title: const Text('已完成提醒')),
      body: completedReminders.isEmpty
          ? const Center(child: Text('还没有已完成的提醒哦，快去添加提醒吧！'))
          : ListView.builder(
        itemCount: completedReminders.length,
        itemBuilder: (context, index) {
          final reminder = completedReminders[index];
          return Slidable(
            key: Key(reminder.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.5, // 两个按钮占宽度的比例
              children: [
                SlidableAction(
                  onPressed: (_) {
                    // 🔁 重新提醒（复用原来的逻辑）
                    final newReminder = Reminder(
                      id: DateTime.now().millisecondsSinceEpoch.toString(), // 新id
                      remindImg: reminder.remindImg,
                      remindTitle: reminder.remindTitle,
                      remindContent: reminder.remindContent,
                      remindTime: reminder.remindTime,
                      remindStartTime: DateTime.now().millisecondsSinceEpoch,
                      remindEndTime: DateTime.now()
                          .add(Duration(milliseconds: reminder.remindTime))
                          .millisecondsSinceEpoch,
                      remindCompleteStatus: false,
                    );
                    context.read<ReminderViewModel>().addReminderFromCompleted(newReminder);
                  },
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  icon: Icons.refresh,
                  label: '重新提醒',
                ),
                SlidableAction(
                  onPressed: (_) {
                    context.read<ReminderViewModel>().removeReminder(reminder);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '删除',
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(reminder.remindTitle),
              subtitle: Text('已完成提醒'),
            ),
          );
        },
      ),
    );
  }
}
