import 'package:flutter/material.dart';

class SettingsReminderPage extends StatelessWidget {
  const SettingsReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('提醒设置'),
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
