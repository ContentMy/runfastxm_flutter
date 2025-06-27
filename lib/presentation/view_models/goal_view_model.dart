import 'package:flutter/material.dart';
import 'package:runfastxm_flutter/domain/models/goal.dart';
import '../../data/repositories_impl/goal_repository_impl.dart';

class GoalViewModel extends ChangeNotifier {
  final GoalRepository _repository;

  GoalViewModel(this._repository);

  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  void loadGoals() {
    _goals = _repository.getAllGoals();
    notifyListeners();
  }

  void addGoal(Goal goal) async {
    await _repository.addGoal(goal);
    loadGoals();
  }

  void updateGoal(Goal goal) async {
    await _repository.updateGoal(goal);
    loadGoals();
  }

  void deleteGoal(String id) async {
    await _repository.deleteGoal(id);
    loadGoals();
  }

  Goal? getGoalById(String id) {
    return _repository.getGoalById(id);
  }
}