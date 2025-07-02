import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:runfastxm_flutter/presentation/views/guide/guide_page.dart';
import 'package:runfastxm_flutter/presentation/views/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRoot extends StatefulWidget {
  const MainRoot({super.key});

  @override
  State<MainRoot> createState() => _MainRootState();
}

class _MainRootState extends State<MainRoot> {
  bool _showGuide = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGuideFlag();
  }

  Future<void> _loadGuideFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final seenGuide = prefs.getBool('seen_guide') ?? false;
    setState(() {
      _showGuide = !seenGuide;
      _loading = false;
    });
  }

  Future<void> _completeGuide() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_guide', true);
    setState(() {
      _showGuide = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: _loading
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : _showGuide
          ? GuidePage(onFinish: _completeGuide)
          : const RunFastApp(),
    );
  }
}
