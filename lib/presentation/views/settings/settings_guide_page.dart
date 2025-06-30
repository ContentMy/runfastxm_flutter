import 'package:flutter/material.dart';

class SettingsGuidePage extends StatelessWidget {
  const SettingsGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('使用说明'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text('暂无', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
