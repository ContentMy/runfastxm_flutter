import 'dart:io';
import 'package:flutter/material.dart';
import '../../../domain/models/diary.dart';
import 'package:intl/intl.dart';

import '../../../resources/strings.dart';

class DiaryDetailPage extends StatelessWidget {
  final Diary diary;

  const DiaryDetailPage({super.key, required this.diary});

  String _formatDate(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasUpdate = diary.updateTime > diary.createTime;

    return Scaffold(
      appBar: AppBar(
        title: const Text( Strings.diaryDetailTitle,
          style: TextStyle(fontSize: 18),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题和时间
            Padding(
              padding: const EdgeInsets.only(left: 12), // 给左边留对齐边距
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    diary.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 时间信息
                  Text(
                    '创建时间: ${_formatDate(diary.createTime)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (hasUpdate) ...[
                    const SizedBox(height: 4),
                    Text(
                      '修改时间: ${_formatDate(diary.updateTime)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 内容框
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                diary.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 图片九宫格
            _buildImageGrid()
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    final imageCount = diary.images.length > 9 ? 9 : diary.images.length;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: imageCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final imagePath = diary.images[index];
        final file = File(imagePath);

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
