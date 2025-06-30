import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/domain/models/goal.dart';
import 'package:runfastxm_flutter/presentation/views/goal/goal_edit_page.dart';

import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/strings.dart';
import '../../view_models/goal_view_model.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  final icons = Assets.goalIconList;

  void _navigateToEdit(BuildContext context, [Goal? goal]) async {
    final result = await Navigator.push<Goal>(
      context,
      MaterialPageRoute(builder: (_) => GoalEditPage(goal: goal)),
    );

    if (result != null) {
      final viewModel = context.read<GoalViewModel>();
      if (goal != null) {
        viewModel.updateGoal(result);
      } else {
        viewModel.addGoal(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalViewModel>(
      builder: (context, viewModel, _) {
        final goals = viewModel.goals;

        return Scaffold(
          appBar: AppBar(title: const Text(Strings.goalTitle)),
          body: goals.isEmpty
              ? const Center(
                  child: Text(
                    Strings.goalEmptyContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.commonGreen),
                  ),
                )
              : ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return GestureDetector(
                      onTap: () => _navigateToEdit(context, goal),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
                              icons[index],
                              width: 24,
                              height: 24,
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
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       DateFormat(
                                  //         'yyyy-MM-dd',
                                  //       ).format(goal.startDateTime),
                                  //       style: const TextStyle(fontSize: 12),
                                  //     ),
                                  //     const Text(
                                  //       ' 至 ',
                                  //       style: TextStyle(fontSize: 12),
                                  //     ),
                                  //     Text(
                                  //       goal.isEndless
                                  //           ? '永久'
                                  //           : DateFormat(
                                  //               'yyyy-MM-dd',
                                  //             ).format(goal.endDateTime),
                                  //       style: const TextStyle(fontSize: 12),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToEdit(context),
            heroTag: null,
            backgroundColor: AppColors.commonGreen,
            shape: const CircleBorder(),
            child: Image.asset(Assets.commonImgAdd, width: 24, height: 24),
          ),
        );
      },
    );
  }
}
