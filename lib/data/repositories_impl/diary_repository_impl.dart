import 'package:hive/hive.dart';
import 'package:runfastxm_flutter/domain/models/diary.dart';

class DiaryRepository {
  final Box<Diary> diaryBox = Hive.box<Diary>('diaries');

  List<Diary> getAllDiaries() {
    return diaryBox.values.toList();
  }

  Future<void> addDiary(Diary diary) async {//异步返回Future，不进行try/catch的话可以不声明async/await，更简洁
    await diaryBox.put(diary.id, diary);
  }

  Future<void> updateDiary(Diary diary) async {
    await diaryBox.put(diary.id, diary);
  }

  Future<void> deleteDiary(String id) async {
    await diaryBox.delete(id);
  }

  Diary? getDiaryById(String id) {
    return diaryBox.get(id);
  }
}
