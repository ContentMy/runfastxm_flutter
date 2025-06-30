import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/diary.dart';
import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/strings.dart';
import '../../view_models/diary_view_model.dart';
import 'diary_create_page.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.diaryTitle),
      ),
      body: Consumer<DiaryViewModel>(
        builder: (context, viewModel, child) {
          final entries = viewModel.diaries;

          // 分组
          Map<String, List<Diary>> groupedEntries = {};
          for (var entry in entries) {
            String key = DateFormat('yyyy-MM-dd').format(entry.createDate);
            groupedEntries.putIfAbsent(key, () => []).add(entry);
          }

          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DiaryCreatePage()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Strings.diaryCreateTitleHint,
                      style: TextStyle(color: AppColors.commonGray),
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
                    style: TextStyle(color: AppColors.commonGreen,fontWeight: FontWeight.w600),
                  ),
                )
                    : Stack(
                  children: [
                    Positioned(
                      left: 32,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.grey[400],
                      ),
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: groupedEntries.length,
                      itemBuilder: (context, index) {
                        String dateKey =
                        groupedEntries.keys.elementAt(index);
                        List<Diary> dayEntries =
                        groupedEntries[dateKey]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 24),
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.green, width: 4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dateKey,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...dayEntries
                                .map((entry) =>
                                _DiaryItem(entry: entry)),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DiaryItem extends StatelessWidget {
  final Diary entry;
  const _DiaryItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (entry.content.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      entry.content,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
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
    );
  }
}

