import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../domain/models/reminder.dart';
import '../view_models/reminder_view_model.dart';
import '../views/reminder/reminder_detail_page.dart';

class ReminderItem extends StatelessWidget {
  final Reminder reminder;

  const ReminderItem({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(reminder.id),

      // 允许向左滑动
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25, // 占 ListTile 的宽度 25%
        children: [
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

      // 主内容
      child: ListTile(
        leading: const Icon(Icons.notifications),
        title: Text(reminder.remindTitle),
        subtitle: Text(
          '提醒时间：${reminder.duration.inMinutes < 60 ? '${reminder.duration.inMinutes}分钟' : '${reminder.duration.inHours}小时'}后',
        ),
        onTap: () {
          // TODO: 跳转提醒详情
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReminderDetailPage(reminder: reminder),
            ),
          );
        },
      ),
    );
  }
}
