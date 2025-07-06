import 'package:flutter/material.dart';
import '../../data/repositories_impl/goal_check_in_repository_impl.dart';
import '../../domain/models/goal_check_in.dart';
class GoalCheckInViewModel extends ChangeNotifier {
  final GoalCheckInRepository _repository;

  GoalCheckInViewModel(this._repository);

  /// 查询今天是否已打卡
  bool isCheckedInToday(String goalId) {
    return _repository.isCheckedIn(goalId, DateTime.now());
  }

  /// 切换打卡状态
  Future<void> toggleCheckIn(String goalId) async {
    final isChecked = isCheckedInToday(goalId);
    if (isChecked) {
      await _repository.removeCheckInByGoalAndDate(goalId, DateTime.now());
    } else {
      final checkIn = GoalCheckIn(
        goalId: goalId,
        checkInDate: GoalCheckIn.normalizeDate(DateTime.now()),
      );
      await _repository.addCheckIn(checkIn);
    }
    notifyListeners();
  }

  Future<void> deleteAllCheckInsByGoal(String goalId) async {
    await _repository.removeCheckIn(goalId);
    notifyListeners();
  }
}
