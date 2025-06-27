import 'package:hive/hive.dart';

part 'diary.g.dart';

@HiveType(typeId: 3)
class Diary extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? icon; // 图片名或资源路径，可为空

  @HiveField(2)
  String title;

  @HiveField(3)
  String content;

  @HiveField(4)
  int createTime; // 时间戳，单位毫秒

  @HiveField(5)
  int updateTime; // 时间戳，单位毫秒

  Diary({
    required this.id,
    this.icon,
    required this.title,
    required this.content,
    required this.createTime,
    required this.updateTime,
  });
}
