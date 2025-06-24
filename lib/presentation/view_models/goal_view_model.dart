import 'package:flutter/material.dart';
import 'package:runfastxm_flutter/domain/models/goal.dart';
import '../../data/repositories_impl/goal_repository_impl.dart';

class GoalViewModel extends ChangeNotifier {
  final GoalRepository repository = GoalRepository();

  GoalViewModel() {
    loadGoals();
  }

  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  void loadGoals() {
    _goals = repository.getAllGoals();
    notifyListeners();
  }

  void addGoal(Goal goal) async {
    await repository.addGoal(goal);
    loadGoals();
  }

  void updateGoal(Goal goal) async {
    await repository.updateGoal(goal);
    loadGoals();
  }

  void deleteGoal(String id) async {
    await repository.deleteGoal(id);
    loadGoals();
  }

  Goal? getGoalById(String id) {
    return repository.getGoalById(id);
  }
}