import 'package:hive/hive.dart';
import '../../domain/models/diary.dart';

class DiaryRepository {
  static const String _boxName = 'diaryBox';

  Future<void> addDiary(Diary diary) async {
    final box = await Hive.openBox<Diary>(_boxName);
    await box.put(diary.id, diary);
  }

  Future<void> updateDiary(Diary diary) async {
    final box = await Hive.openBox<Diary>(_boxName);
    await box.put(diary.id, diary);
  }

  Future<void> deleteDiary(String id) async {
    final box = await Hive.openBox<Diary>(_boxName);
    await box.delete(id);
  }

  Future<List<Diary>> getAllDiaries() async {
    final box = await Hive.openBox<Diary>(_boxName);
    return box.values.toList();
  }

  Future<Diary?> getDiaryById(String id) async {
    final box = await Hive.openBox<Diary>(_boxName);
    return box.get(id);
  }
}
