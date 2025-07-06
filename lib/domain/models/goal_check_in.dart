import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'goal_check_in.g.dart';

@HiveType(typeId: 3) // ⚠️ 记得唯一且不冲突
class GoalCheckIn extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String goalId;

  @HiveField(2)
  final int checkInDate; // 用时间戳保存当天 00:00 的时间

  GoalCheckIn({
    String? id,
    required this.goalId,
    required this.checkInDate,
  }) : id = id ?? const Uuid().v4();

  // 辅助 getter
  DateTime get date =>
      DateTime.fromMillisecondsSinceEpoch(checkInDate);

  /// 用于统一当天 00:00 时间戳（防止跨小时导致 bug）
  static int normalizeDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.millisecondsSinceEpoch;
  }
}

