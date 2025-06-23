import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/presentation/views/settings/settings_page.dart';
import 'package:runfastxm_flutter/services/notification_service.dart';
import 'domain/models/reminder.dart';
import 'presentation/view_models/reminder_view_model.dart';
import 'presentation/views/reminder/reminder_page.dart';

void main() async{
  //以下是hive初始化的代码部分
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox<Reminder>('reminders');

  await NotificationService.init(); // 初始化通知插件

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderViewModel()),
      ],
      child: const RunFastApp(),
    ),
  );
}

class RunFastApp extends StatelessWidget {
  const RunFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunFast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

  final List<Widget> _pages = const [
    ReminderPage(),
    Placeholder(child: Center(child: Text('目标'))),
    Placeholder(child: Center(child: Text('日记'))),
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
        selectedItemColor: Colors.blue,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '提醒'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: '目标'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '日记'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
