import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/presentation/widgets/goal_item.dart';
import '../../../domain/models/goal.dart';
import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/strings.dart';
import '../../view_models/goal_view_model.dart';
import 'goal_edit_page.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

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
              style: TextStyle(
                  color: AppColors.commonGreen,
                  fontWeight: FontWeight.w600),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GoalItem(goal: goal, iconIndex: goal.iconIndex,),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToEdit(context),
            heroTag: null,
            backgroundColor: AppColors.commonGreen,
            shape: const CircleBorder(),
            child:
            Image.asset(Assets.commonImgAdd, width: 24, height: 24),
          ),
        );
      },
    );
  }
}
