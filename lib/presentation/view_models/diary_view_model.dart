import 'package:flutter/material.dart';
import '../../data/repositories_impl/diary_repository_impl.dart';
import '../../domain/models/diary.dart';


class DiaryViewModel extends ChangeNotifier {
  final DiaryRepository _repository;

  List<Diary> _diaries = [];

  List<Diary> get diaries => _diaries;

  String? _selectedId;

  String? get selectedId => _selectedId;

  DiaryViewModel(this._repository){
    loadDiaries();
  }

  /// 加载所有日记
  void loadDiaries() {
    _diaries = _repository.getAllDiaries();
    notifyListeners();
  }

  /// 新增日记
  Future<void> addDiary(Diary diary) async {
    await _repository.addDiary(diary);
    loadDiaries();
  }

  /// 更新日记
  Future<void> updateDiary(Diary diary) async {
    await _repository.updateDiary(diary);
    loadDiaries();
  }

  /// 删除日记
  Future<void> deleteDiary(String id) async {
    await _repository.deleteDiary(id);
    loadDiaries();
  }

  Diary? getDiaryById(String id) {
    return _repository.getDiaryById(id);
  }


  void selectDiary(String id) {
    _selectedId = id;
    notifyListeners();
  }

  void clearSelection() {
    if (_selectedId != null) {
      _selectedId = null;
      notifyListeners();
    }
  }
}

