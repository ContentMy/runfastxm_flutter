import 'package:flutter/material.dart';
import 'package:runfastxm_flutter/presentation/views/settings/settings_about_page.dart';
import 'package:runfastxm_flutter/presentation/views/settings/settings_guide_page.dart';
import 'package:runfastxm_flutter/presentation/views/settings/settings_privacy_page.dart';
import 'package:runfastxm_flutter/presentation/views/settings/settings_reminder_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SettingItem> items = [
      _SettingItem(Icons.info, '关于小马快跑', onTap: () {
        // 跳转关于页面
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsAboutPage()),
        );
      }),
      _SettingItem(Icons.privacy_tip, '隐私政策与用户协议', onTap: () {
        // 跳转隐私页面
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPrivacyPage()),
        );
      }),
      _SettingItem(Icons.help_outline, '使用说明', onTap: () {
        // 跳转使用说明
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsGuidePage()),
        );
      }),
      _SettingItem(Icons.notifications_active, '提醒设置', onTap: () {
        // 跳转提醒设置
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsReminderPage()),
        );
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人设置'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Center(
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/icons/ic_launcher.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '小马快跑',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),
          ...items.map((item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            onTap: item.onTap,
          )),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _SettingItem(this.icon, this.title, {required this.onTap});
}
