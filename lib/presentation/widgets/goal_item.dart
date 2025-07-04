import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../domain/models/goal.dart';
import '../../resources/assets.dart';
import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../view_models/goal_check_in_view_model.dart';
import '../view_models/goal_view_model.dart';
import '../views/goal/goal_edit_page.dart';

class GoalItem extends StatelessWidget {
  final Goal goal;
  final int iconIndex;

  const GoalItem({
    super.key,
    required this.goal,
    required this.iconIndex,
  });

  void _navigateToEdit(BuildContext context) async {
    final result = await Navigator.push<Goal>(
      context,
      MaterialPageRoute(builder: (_) => GoalEditPage(goal: goal)),
    );

    if (result != null) {
      context.read<GoalViewModel>().updateGoal(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalCheckInViewModel>(
      builder: (context, checkInVM, _) {
        final isCheckedIn = checkInVM.isCheckedInToday(goal.id);

        return Slidable(
          key: ValueKey(goal.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (_) {
                  context.read<GoalViewModel>().deleteGoal(goal.id);
                },
                backgroundColor: AppColors.commonGreen,
                foregroundColor: AppColors.commonWhite,
                label: Strings.deleteString,
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () => _navigateToEdit(context),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.commonGreenMidNext,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.commonBlack),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.commonBlackShadow,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    Assets.goalIconList[iconIndex % Assets.goalIconList.length],
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goal.content,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.commonGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isCheckedIn ? Colors.grey : AppColors.commonGreen,
                    ),
                    onPressed: () {
                      checkInVM.toggleCheckIn(goal.id);
                    },
                    child: Text(
                      isCheckedIn ? '已打卡' : '打卡',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
