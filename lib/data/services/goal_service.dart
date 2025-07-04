import '../repositories_impl/goal_check_in_repository_impl.dart';
import '../repositories_impl/goal_repository_impl.dart';

class GoalService {
  final GoalRepository goalRepository;
  final GoalCheckInRepository checkInRepository;

  GoalService(this.goalRepository, this.checkInRepository);

  Future<void> deleteGoalWithCheckIns(String goalId) async {
    // 查出所有该目标的打卡记录
    final checkIns = checkInRepository.getCheckInsByGoal(goalId);

    // 删除所有打卡记录
    for (final checkIn in checkIns) {
      await checkInRepository.removeCheckIn(checkIn.id);
    }

    // 删除目标
    await goalRepository.deleteGoal(goalId);
  }
}
