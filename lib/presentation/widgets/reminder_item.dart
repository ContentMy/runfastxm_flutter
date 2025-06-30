import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/resources/strings.dart';
import '../../domain/models/reminder.dart';
import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../view_models/reminder_view_model.dart';
import '../views/reminder/reminder_detail_page.dart';

class ReminderItem extends StatelessWidget {
  final Reminder reminder;

  const ReminderItem({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(reminder.id),

      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              context.read<ReminderViewModel>().removeReminder(reminder);
            },
            backgroundColor: AppColors.commonGreen, // 用更醒目的颜色
            foregroundColor: AppColors.commonWhite,
            label: Strings.deleteString,
          ),
        ],
      ),

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.commonGreenMidNextLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.commonBlack, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.commonBlackShadow,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Image.asset(
            Assets.reminderImgRemind,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          title: Text(
            reminder.remindTitle,
            style: const TextStyle(color: AppColors.commonBlack),
          ),
          // subtitle: Text(
          //   '提醒时间：${reminder.duration.inMinutes < 60 ? '${reminder.duration.inMinutes}分钟' : '${reminder.duration.inHours}小时'}后',
          //   style: const TextStyle(color: Colors.white70),
          // ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReminderDetailPage(reminder: reminder),
              ),
            );
          },
        ),
      ),
    );
  }
}


