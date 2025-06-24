import 'package:hive/hive.dart';
import 'package:runfastxm_flutter/domain/models/goal.dart';

class GoalRepository {
  final Box<Goal> goalBox = Hive.box<Goal>('goals');

  List<Goal> getAllGoals() {
    return goalBox.values.toList();
  }

  Future<void> addGoal(Goal goal) async {
    await goalBox.put(goal.id, goal);
  }

  Future<void> updateGoal(Goal goal) async {
    await goalBox.put(goal.id, goal);
  }

  Future<void> deleteGoal(String id) async {
    await goalBox.delete(id);
  }

  Goal? getGoalById(String id) {
    return goalBox.get(id);
  }
}
