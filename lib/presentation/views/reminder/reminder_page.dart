import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/presentation/views/reminder/remind_guide_overlay.dart';
import 'package:runfastxm_flutter/presentation/views/settings/settings_reminder_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/strings.dart';
import '../../widgets/main_title_with_bg.dart';
import '../../widgets/remind_optimization_banner.dart';
import 'reminder_completed_page.dart';
import '../../../services/permission_service.dart';
import '../../view_models/reminder_view_model.dart';
import 'reminder_input_sheet.dart';
import '../../widgets/reminder_item.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final GlobalKey fabKey = GlobalKey();
  final GlobalKey menuKey = GlobalKey();
  bool showOptimizationBanner = true;

  void _handleOptimizationJump() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasShownOptimizationBanner', true);

    if (!mounted) return;//防止context警告，异步执行完可能会离开当前页面或者其他操作导致context无效

    setState(() {
      showOptimizationBanner = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsReminderPage(),
      ),
    );
  }


  void _handleOptimizationClose() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasShownOptimizationBanner', true);

    setState(() {
      showOptimizationBanner = false;
    });
  }


  @override
  void initState() {
    super.initState();
    _checkGuide();
    _loadOptimizationBanner();
  }

  Future<void> _checkGuide() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownGuide = prefs.getBool('hasShownReminderGuide') ?? false;

    if (!hasShownGuide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => RemindGuideOverlay(
              fabKey: fabKey,
              menuKey: menuKey,
              onClose: () {
                // ✅ 设置为已展示
                prefs.setBool('hasShownReminderGuide', true);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      });
    }
  }

  Future<void> _loadOptimizationBanner() async {
    final prefs = await SharedPreferences.getInstance();
    final hasClosed = prefs.getBool('hasShownOptimizationBanner') ?? false;

    setState(() {
      showOptimizationBanner = !hasClosed;
    });
  }


  void _showAddReminderSheet(BuildContext context) async {
    await PermissionService.requestNotificationPermission();
    await PermissionService.requestExactAlarmPermission();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReminderInputSheet(
        onSubmit: (text, duration) {
          context.read<ReminderViewModel>().addReminder(text, duration);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainTitleWithBg(title: Strings.reminderTitle),
        actions: [
          IconButton(
            key: menuKey,
            icon: Image.asset(Assets.reminderImgMenu, width: 24, height: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReminderCompletedPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (showOptimizationBanner)
            ReminderOptimizationBanner(
              onJump: _handleOptimizationJump,
              onClose: _handleOptimizationClose,
            ),
          const Expanded(child: _ReminderBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: fabKey,
        heroTag: null,
        backgroundColor: AppColors.commonGreen,
        shape: const CircleBorder(),
        onPressed: () => _showAddReminderSheet(context),
        child: Image.asset(Assets.commonImgAdd, width: 24, height: 24),
      ),
    );
  }
}

class _ReminderBody extends StatelessWidget {
  const _ReminderBody();

  @override
  Widget build(BuildContext context) {
    final reminders = context.watch<ReminderViewModel>().reminders;

    return reminders.isEmpty
        ? const Center(
            child: Text(
              Strings.reminderEmptyContent,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.commonGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ReminderItem(reminder: reminder),
              );
            },
          );
  }
}
