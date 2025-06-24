import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/domain/models/goal.dart';
import 'package:runfastxm_flutter/presentation/views/goal/goal_edit_page.dart';

import '../../view_models/goal_view_model.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  final List<IconData> icons = const [
    Icons.star, Icons.book, Icons.fitness_center, Icons.music_note,
    Icons.palette, Icons.code, Icons.language, Icons.camera_alt, Icons.travel_explore,
  ];

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
          appBar: AppBar(title: const Text('目标列表')),
          body: goals.isEmpty
              ? const Center(child: Text('暂无目标，点击右下角添加'))
              : ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return GestureDetector(
                onTap: () => _navigateToEdit(context, goal),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(icons[goal.iconIndex], color: Colors.black),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(goal.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(goal.content,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd').format(goal.startDateTime),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Text(' 至 ', style: TextStyle(fontSize: 12)),
                                Text(
                                  goal.isEndless
                                      ? '永久'
                                      : DateFormat('yyyy-MM-dd').format(goal.endDateTime),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
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
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
