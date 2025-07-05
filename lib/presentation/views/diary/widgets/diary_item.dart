import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/models/diary.dart';
import '../../../../resources/assets.dart';
import '../../../view_models/diary_view_model.dart';

class DiaryItem extends StatelessWidget {
  final Diary entry;

  const DiaryItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DiaryViewModel>();
    final isSelected = viewModel.selectedId == entry.id;

    return GestureDetector(
      onLongPress: () => viewModel.selectDiary(entry.id),
      onTap: () {
        if (isSelected) viewModel.clearSelection();
      },
      child: Stack(
        clipBehavior: Clip.none,//兼容超出布局的部分不会被裁剪
        children: [
          Container(
            margin: const EdgeInsets.only(left: 56, right: 16, bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade300,
                  offset: const Offset(2, 2),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(Assets.diaryImgSmail, width: 36, height: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      if (entry.content.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(entry.content,
                              style: const TextStyle(fontSize: 14, color: Colors.black54)),
                        ),
                      if (entry.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              entry.icon!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: -5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  context.read<DiaryViewModel>().deleteDiary(entry.id);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
