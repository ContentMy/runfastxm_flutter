
import 'package:hive/hive.dart';
part 'reminder.g.dart'; //声明后执行flutter pub run build_runner build自动生成.g.dart

@HiveType(typeId: 0)
class Reminder extends HiveObject {
  @HiveField(0)
  final String id; // 数据库主键，nullable，因为新增时没id

  @HiveField(1)
  final String remindImg; // 对应 remindImg 图标路径或名称

  @HiveField(2)
  final String remindTitle; // 标题

  @HiveField(3)
  final String remindContent; // 详情内容

  @HiveField(4)
  final int remindTime; // 间隔时间，单位毫秒

  @HiveField(5)
  final int remindStartTime; // 创建时间戳，单位毫秒

  @HiveField(6)
  final int remindEndTime; // 结束时间戳，单位毫秒

  @HiveField(7)
  final bool remindCompleteStatus; // 是否完成

  Reminder({
    required this.id,
    required this.remindImg,
    required this.remindTitle,
    required this.remindContent,
    required this.remindTime,
    required this.remindStartTime,
    required this.remindEndTime,
    this.remindCompleteStatus = false,
  });

  // 可选：添加辅助getter，将时间戳转为DateTime
  DateTime get startDateTime => DateTime.fromMillisecondsSinceEpoch(remindStartTime);
  DateTime get endDateTime => DateTime.fromMillisecondsSinceEpoch(remindEndTime);

  Duration get duration => Duration(milliseconds: remindTime);

  Reminder copyWith({
    String? id,
    String? remindImg,
    String? remindTitle,
    String? remindContent,
    int? remindTime,
    int? remindStartTime,
    int? remindEndTime,
    bool? remindCompleteStatus,
  }) {
    return Reminder(
      id: id ?? this.id,
      remindImg: remindImg ?? this.remindImg,
      remindTitle: remindTitle ?? this.remindTitle,
      remindContent: remindContent ?? this.remindContent,
      remindTime: remindTime ?? this.remindTime,
      remindStartTime: remindStartTime ?? this.remindStartTime,
      remindEndTime: remindEndTime ?? this.remindEndTime,
      remindCompleteStatus: remindCompleteStatus ?? this.remindCompleteStatus,
    );
  }

}

