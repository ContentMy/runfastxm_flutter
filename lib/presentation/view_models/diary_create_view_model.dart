import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DiaryCreateViewModel extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final List<File> images = [];

  final ImagePicker _picker = ImagePicker();

  void disposeControllers() {
    titleController.dispose();
    contentController.dispose();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      images.add(File(pickedFile.path));
      notifyListeners();
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  bool validateTitle(BuildContext context) {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('标题不能为空')),
      );
      return false;
    }
    return true;
  }

  void reset() {
    titleController.clear();
    contentController.clear();
    images.clear();
    notifyListeners();
  }
}
