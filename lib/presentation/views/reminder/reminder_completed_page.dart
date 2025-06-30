import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/resources/strings.dart';
import '../../../domain/models/reminder.dart';
import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../view_models/reminder_view_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ReminderCompletedPage extends StatelessWidget {
  const ReminderCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final completedReminders =
        context.watch<ReminderViewModel>().completedReminders;

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.reminderCompletedTitle)),
      body: completedReminders.isEmpty
          ? const Center(child: Text(Strings.reminderCompletedEmptyContent))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: completedReminders.length,
        itemBuilder: (context, index) {
          final reminder = completedReminders[index];
          return Slidable(
            key: Key(reminder.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.6,
              children: [
                SlidableAction(
                  flex: 3, // 分到更多空间
                  onPressed: (_) {
                    context
                        .read<ReminderViewModel>()
                        .addReminderFromCompleted(reminder.copyWith(
                      remindCompleteStatus: false,
                      remindStartTime: DateTime.now().millisecondsSinceEpoch,
                      remindEndTime: DateTime.now()
                          .add(Duration(milliseconds: reminder.remindTime))
                          .millisecondsSinceEpoch,
                    ));
                  },
                  backgroundColor: AppColors.commonGreen,
                  foregroundColor: AppColors.commonWhite,
                  label: Strings.remindResetString,
                ),
                SlidableAction(
                  flex: 2, // 分到更多空间
                  onPressed: (_) {
                    context.read<ReminderViewModel>().removeReminder(reminder);
                  },
                  backgroundColor: AppColors.commonGray,
                  foregroundColor: AppColors.commonWhite,
                  label: Strings.deleteString,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.commonGrayLight, // 或你指定的颜色
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.commonBlack),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.commonBlackShadow,
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Image.asset(
                  Assets.reminderImgRemindCompleted,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  reminder.remindTitle,
                  style: const TextStyle(color: AppColors.commonBlack),
                ),
                // subtitle: const Text(
                //   '已完成提醒',
                //   style: TextStyle(color: Colors.white70),
                // ),
              ),
            ),
          );

        },
      ),
    );
  }
}
