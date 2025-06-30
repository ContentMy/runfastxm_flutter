import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/resources/colors.dart';
import 'package:runfastxm_flutter/resources/strings.dart';
import '../../../domain/models/diary.dart';
import '../../view_models/diary_view_model.dart';

class DiaryCreatePage extends StatefulWidget {
  const DiaryCreatePage({super.key});

  @override
  State<DiaryCreatePage> createState() => _DiaryCreatePageState();
}

class _DiaryCreatePageState extends State<DiaryCreatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveDiary() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('标题不能为空')));
      return;
    }

    final now = DateTime.now();

    final newDiary = Diary(
      title: title,
      content: content,
      createTime: now.millisecondsSinceEpoch,
      updateTime: now.millisecondsSinceEpoch,
    );

    await context.read<DiaryViewModel>().addDiary(newDiary);

    Navigator.pop(context); // 回到列表页
  }

  @override
  Widget build(BuildContext context) {
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
              width: 64, // ✅ 这里设置宽度
              height: 32, // ✅ 这里设置高度
              child: ElevatedButton(
                onPressed: _saveDiary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.commonGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero, // ✅ 去除内部默认 padding
                ),
                child: const Text(
                  Strings.saveString,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14, // ✅ 可进一步缩小文字
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
                controller: _titleController,
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
              const SizedBox(height: 24),
              const Text(
                Strings.diaryCreateContentPrompt,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
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
            ],
          ),
        ),
      ),
    );
  }
}
