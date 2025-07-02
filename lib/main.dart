import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:runfastxm_flutter/data/repositories_impl/goal_repository_impl.dart';
import 'package:runfastxm_flutter/data/repositories_impl/reminder_repository_impl.dart';
import 'package:runfastxm_flutter/domain/models/diary.dart';
import 'package:runfastxm_flutter/presentation/view_models/diary_view_model.dart';
import 'package:runfastxm_flutter/presentation/views/main_root.dart';
import 'package:runfastxm_flutter/services/notification_service.dart';
import 'data/repositories_impl/diary_repository_impl.dart';
import 'domain/models/goal.dart';
import 'domain/models/reminder.dart';
import 'presentation/view_models/reminder_view_model.dart';
import 'presentation/view_models/goal_view_model.dart';

void main() async {
  //以下是hive初始化的代码部分
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox<Reminder>('reminders');
  Hive.registerAdapter(GoalAdapter());
  await Hive.openBox<Goal>('goals');
  Hive.registerAdapter(DiaryAdapter());
  await Hive.openBox<Diary>('diaries');

  await NotificationService.init(); // 初始化通知插件

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ReminderViewModel(ReminderRepository())),
        ChangeNotifierProvider(create: (_) => GoalViewModel(GoalRepository())),
        ChangeNotifierProvider(
          create: (_) => DiaryViewModel(DiaryRepository()),

          ///这种写法直接在viewmodel中的构造方法里处理调用
          // create: (_) => DiaryViewModel(DiaryRepository())..loadDiaries(),///这种写法适合有单元测试避免自动加载或者手动可控延迟加载的场景
        ),
      ],
      child: const MainRoot(),
    ),
  );
}

