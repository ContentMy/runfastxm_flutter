import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/diary.dart';
import '../../../resources/colors.dart';
import '../../../resources/strings.dart';
import '../../view_models/diary_create_view_model.dart';
import '../../view_models/diary_view_model.dart';
import '../../widgets/diary_image_grid.dart';

class DiaryCreatePage extends StatelessWidget {
  const DiaryCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiaryCreateViewModel(),
      child: Consumer<DiaryCreateViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                Strings.diaryCreateTitle,
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 64,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!vm.validateTitle(context)) return;

                        final now = DateTime.now();
                        final newDiary = Diary(
                          title: vm.titleController.text.trim(),
                          content: vm.contentController.text.trim(),
                          createTime: now.millisecondsSinceEpoch,
                          updateTime: now.millisecondsSinceEpoch,
                          images: vm.images.map((e) => e.path).toList(),
                        );

                        await context.read<DiaryViewModel>().addDiary(newDiary);

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.commonGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        Strings.saveString,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: vm.titleController,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: Strings.diaryCreateTitleHint,
                        hintStyle: TextStyle(color: AppColors.commonGray),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      Strings.diaryCreateContentPrompt,
                      style: TextStyle(fontSize: 12, color:  AppColors.commonGray),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: vm.contentController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: Strings.diaryCreateContentHint,
                        hintStyle: TextStyle(color: AppColors.commonGray),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      Strings.diaryCreateImagePrompt,
                      style: TextStyle(fontSize: 12, color: AppColors.commonGray),
                    ),
                    const SizedBox(height: 12),
                    DiaryImageGrid(
                      images: vm.images,
                      onAdd: vm.pickImage,
                      onRemove: vm.removeImage,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
