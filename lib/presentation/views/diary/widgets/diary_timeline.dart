import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/models/diary.dart';
import 'diary_item.dart';

class DiaryTimeline extends StatelessWidget {
  final List<Diary> entries;

  const DiaryTimeline({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Diary>> grouped = {};

    for (var entry in entries) {
      String key = DateFormat('yyyy-MM-dd').format(entry.createDate);
      grouped.putIfAbsent(key, () => []).add(entry);
    }

    return Stack(
      children: [
        Positioned(
          left: 32,
          top: 0,
          bottom: 0,
          child: Container(width: 2, color: Colors.grey[400]),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: grouped.length,
          itemBuilder: (context, index) {
            String dateKey = grouped.keys.elementAt(index);
            List<Diary> dayEntries = grouped[dateKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 24),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.green, width: 4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(dateKey,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 8),
                ...dayEntries.map((e) => DiaryItem(entry: e)),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ],
    );
  }
}
