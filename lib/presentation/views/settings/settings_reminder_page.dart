import 'package:flutter/material.dart';
import 'package:runfastxm_flutter/resources/assets.dart';
import 'package:runfastxm_flutter/resources/strings.dart';

import '../../../resources/colors.dart';
import '../../../services/native_reminder_service.dart';
import '../../widgets/setting_item.dart';

class SettingsReminderPage extends StatefulWidget {
  const SettingsReminderPage({super.key});

  @override
  State<SettingsReminderPage> createState() => _SettingsReminderPageState();
}

class _SettingsReminderPageState extends State<SettingsReminderPage> with WidgetsBindingObserver {
  bool isNotificationEnabled = false;
  bool isAutoStartEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("App resumed → 刷新权限状态");
      _loadStatus();
    }
  }

  Future<void> _loadStatus() async {
    final notificationStatus =
    await NativeReminderService.isNotificationEnabled();
    final autoStartStatus =
    await NativeReminderService.isAutoStartEnabled();

    setState(() {
      isNotificationEnabled = notificationStatus;
      isAutoStartEnabled = autoStartStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.commonWhite,
        foregroundColor: AppColors.commonBlack,
        title: const Text(Strings.settingsNotificationTitle),
        centerTitle: true,
      ),
      backgroundColor: AppColors.commonWhite,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SettingItem(
              iconAsset: Assets.reminderImgRemind,
              title: Strings.settingsNotificationRemindContent,
              status: isNotificationEnabled
                  ? Strings.settingsNotificationRemindTrue
                  : Strings.settingsNotificationRemindFalse,
              arrowAsset: Assets.guideImgTurnRight,
              onTap: () async {
                await NativeReminderService.openNotificationSettings();
                await _loadStatus();
              },
            ),
            const SizedBox(height: 16),
            SettingItem(
              iconAsset: Assets.settingImgRemindSelfStart,
              title: Strings.settingsNotificationSelfStartContent,
              // status: isAutoStartEnabled
              //     ? Strings.settingsNotificationSelfStartTrue
              //     : Strings.settingsNotificationSelfStartFalse,
              arrowAsset: Assets.guideImgTurnRight,
              onTap: () async {
                await NativeReminderService.openAutoStartSettings();
                await _loadStatus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
