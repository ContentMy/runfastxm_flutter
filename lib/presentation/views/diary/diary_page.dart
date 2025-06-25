import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runfastxm_flutter/presentation/views/diary/diary_create_page.dart';

class DiaryEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final String? imageUrl;

  DiaryEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    this.imageUrl,
  });
}

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DiaryEntry> entries = [
      DiaryEntry(
        id: '1',
        date: DateTime(2024, 6, 5),
        title: '心情是开心',
        content: '测试版马上完成了',
      ),
      DiaryEntry(
        id: '2',
        date: DateTime(2024, 6, 13),
        title: '有图版',
        content: '',
      ),
    ];

    Map<String, List<DiaryEntry>> groupedEntries = {};
    for (var entry in entries) {
      String key = DateFormat('yyyy-MM-dd').format(entry.date);
      groupedEntries.putIfAbsent(key, () => []).add(entry);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('记录生活'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: 跳转到新建记录页面
              Navigator.push(
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
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '记录一下今天的心情吧',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
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
                    String dateKey = groupedEntries.keys.elementAt(index);
                    List<DiaryEntry> dayEntries = groupedEntries[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Text(
                              dateKey,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...dayEntries.map((entry) => _DiaryItem(entry: entry)).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryItem extends StatelessWidget {
  final DiaryEntry entry;
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
          const Icon(Icons.sentiment_satisfied, size: 40),
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
                        style: const TextStyle(color: Colors.black54, fontSize: 14)),
                  ),
                if (entry.imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        entry.imageUrl!,
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
