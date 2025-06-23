import 'package:flutter/material.dart';

class SettingsAboutPage extends StatelessWidget {
  const SettingsAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // 保持干净背景
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 设置透明
        elevation: 0,                         // 去除阴影
        foregroundColor: Colors.white, // ✅ 返回键、标题变白
        title: const Text(
          '小马快跑',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 应用图标
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/icons/ic_launcher.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '小马快跑',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '测试版 0.0.1',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
