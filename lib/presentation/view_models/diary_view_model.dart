import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories_impl/diary_repository_impl.dart';
import '../../domain/models/diary.dart';

class DiaryViewModel extends ChangeNotifier {
  final DiaryRepository _repository = DiaryRepository();

  List<Diary> _diaries = [];

  List<Diary> get diaries => _diaries;

  Future<void> loadDiaries() async {
    _diaries = await _repository.getAllDiaries();
    notifyListeners();
  }

  Future<void> addDiary({
    String? icon,
    required String title,
    required String content,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final diary = Diary(
      id: const Uuid().v4(),
      icon: icon,
      title: title,
      content: content,
      createTime: now,
      updateTime: now,
    );
    await _repository.addDiary(diary);
    await loadDiaries();
  }

  Future<void> updateDiary(Diary diary) async {
    diary.updateTime = DateTime.now().millisecondsSinceEpoch;
    await _repository.updateDiary(diary);
    await loadDiaries();
  }

  Future<void> deleteDiary(String id) async {
    await _repository.deleteDiary(id);
    await loadDiaries();
  }
}
