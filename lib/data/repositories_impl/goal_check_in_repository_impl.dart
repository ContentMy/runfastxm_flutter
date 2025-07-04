import 'package:hive/hive.dart';
import '../../domain/models/goal_check_in.dart';

class GoalCheckInRepository {
  static const _boxName = 'goal_check_ins';

  final Box<GoalCheckIn> box = Hive.box<GoalCheckIn>(_boxName);

  /// 新增打卡
  Future<void> addCheckIn(GoalCheckIn checkIn) async {
    await box.put(checkIn.id, checkIn);
  }

  /// 删除打卡（根据 id）
  Future<void> removeCheckIn(String checkInId) async {
    await box.delete(checkInId);
  }

  /// 删除某天某个目标的打卡
  Future<void> removeCheckInByGoalAndDate(String goalId, DateTime date) async {
    int dateKey = GoalCheckIn.normalizeDate(date);

    GoalCheckIn? matchingEntry;
    try {
      matchingEntry = box.values.firstWhere(
            (checkIn) =>
        checkIn.goalId == goalId && checkIn.checkInDate == dateKey,
      );
    } catch (e) {
      matchingEntry = null;
    }

    if (matchingEntry != null) {
      await box.delete(matchingEntry.id);
    }
  }

  /// 查询某个目标所有打卡
  List<GoalCheckIn> getCheckInsByGoal(String goalId) {
    return box.values
        .where((checkIn) => checkIn.goalId == goalId)
        .toList();
  }

  /// 查询某天是否已打卡
  bool isCheckedIn(String goalId, DateTime date) {
    int dateKey = GoalCheckIn.normalizeDate(date);
    return box.values.any(
          (checkIn) =>
      checkIn.goalId == goalId && checkIn.checkInDate == dateKey,
    );
  }
}

