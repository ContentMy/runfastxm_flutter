// domain/models/diary.dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'diary.g.dart';

@HiveType(typeId: 2)
class Diary extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? icon;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final int createTime;

  @HiveField(5)
  final int updateTime;

  Diary({
    String? id,
    this.icon,
    required this.title,
    required this.content,
    required this.createTime,
    required this.updateTime,
  }) : id = id ?? const Uuid().v4();

  Diary copyWith({
    String? id,
    String? icon,
    String? title,
    String? content,
    int? createTime,
    int? updateTime,
  }) {
    return Diary(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      content: content ?? this.content,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  DateTime get createDate => DateTime.fromMillisecondsSinceEpoch(createTime);
  DateTime get updateDate => DateTime.fromMillisecondsSinceEpoch(updateTime);
}
