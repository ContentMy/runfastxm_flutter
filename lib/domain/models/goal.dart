import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int iconIndex;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final int startTime;

  @HiveField(4)
  final int endTime;

  @HiveField(5)
  final int statusIndex;

  @HiveField(6)
  final String content;

  @HiveField(7)
  final bool needRemind;

  Goal({
    String? id,
    required this.iconIndex,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.statusIndex,
    this.content = "",
    this.needRemind = false,
  }) : id = id ?? const Uuid().v4();

  // 辅助 Getter
  DateTime get startDateTime => DateTime.fromMillisecondsSinceEpoch(startTime);
  DateTime get endDateTime => DateTime.fromMillisecondsSinceEpoch(endTime);
  bool get isEndless => endTime == 0;

  // 复制方法用于更新
  Goal copyWith({
    String? id,
    int? iconIndex,
    String? title,
    int? startTime,
    int? endTime,
    int? statusIndex,
    String? content,
    bool? needRemind,
  }) {
    return Goal(
      id: id ?? this.id,
      iconIndex: iconIndex ?? this.iconIndex,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      statusIndex: statusIndex ?? this.statusIndex,
      content: content ?? this.content,
      needRemind: needRemind ?? this.needRemind,
    );
  }
}