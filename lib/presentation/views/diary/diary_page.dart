import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../resources/colors.dart';
import '../../../resources/strings.dart';
import '../../view_models/diary_view_model.dart';
import 'diary_create_page.dart';
import 'widgets/diary_timeline.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域取消所有编辑状态
      onTap: () => context.read<DiaryViewModel>().clearSelection(),
      child: Scaffold(
        appBar: AppBar(title: const Text(Strings.diaryTitle)),
        body: Consumer<DiaryViewModel>(
          builder: (context, viewModel, _) {
            final entries = viewModel.diaries;

            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DiaryCreatePage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Strings.diaryCreateTitleHint,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: entries.isEmpty
                      ? const Center(
                          child: Text(
                            Strings.diaryEmptyContent,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.commonGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : DiaryTimeline(entries: entries),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
