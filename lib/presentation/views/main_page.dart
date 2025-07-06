import 'package:flutter/material.dart';

import '../../resources/assets.dart';
import '../../resources/colors.dart';
import 'diary/diary_page.dart';
import 'goal/goal_page.dart';
import 'reminder/reminder_page.dart';
import 'settings/settings_page.dart';


class RunFastApp extends StatelessWidget {
  const RunFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunFast',
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ReminderPage(),
    GoalPage(),
    DiaryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.commonGreen,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(icon: ImageIcon(
            AssetImage(Assets.commonNavIconRemind),
            size: 24,
          ), label: '提醒',),
          const BottomNavigationBarItem(icon: ImageIcon(
            AssetImage(Assets.commonNavIconGoal),
            size: 24,
          ), label: '目标'),
          const BottomNavigationBarItem(icon: ImageIcon(
            AssetImage(Assets.commonNavIconMemorandum),
            size: 24,
          ), label: '日记'),
          const BottomNavigationBarItem(icon: ImageIcon(
            AssetImage(Assets.commonNavIconUser),
            size: 24,
          ), label: '我的'),
        ],
      ),
    );
  }
}