import 'package:flutter/material.dart';

class SettingsPrivacyPage extends StatelessWidget {
  const SettingsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // 黑色返回按钮和标题
        title: const Text('隐私政策与用户协议'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          '暂无',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
