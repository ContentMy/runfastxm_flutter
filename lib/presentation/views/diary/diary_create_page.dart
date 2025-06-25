import 'package:flutter/material.dart';

class DiaryCreatePage extends StatelessWidget {
  const DiaryCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新建记录'),
        centerTitle: true, // ✅ 解决标题不居中的问题
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              onPressed: () {
                // 保存逻辑
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('保存',style: TextStyle(color: Colors.white)),
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
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: '记录一下今天的心情吧', // ✅ 提示文字
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '记录一下详细内容吧：',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: '我还想说...', // ✅ 提示文字
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              // const Text(
              //   '选择想要添加的图片吧：',
              //   style: TextStyle(fontSize: 14, color: Colors.black54),
              // ),
              // const SizedBox(height: 12),
              // Container(
              //   width: 100,
              //   height: 100,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.green, style: BorderStyle.solid, width: 2),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: const Center(
              //     child: Icon(Icons.add, color: Colors.green, size: 32),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
