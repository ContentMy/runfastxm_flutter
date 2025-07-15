import 'package:flutter/material.dart';
import 'package:runfastxm_flutter/resources/assets.dart';
import 'package:runfastxm_flutter/resources/strings.dart';

import '../../resources/colors.dart';

class ReminderOptimizationBanner extends StatelessWidget {
  final VoidCallback onJump;
  final VoidCallback onClose;

  const ReminderOptimizationBanner({
    super.key,
    required this.onJump,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.commonGreenMidNextLight, // 浅绿色背景
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 左侧图标
              Image.asset(
                Assets.reminderImgRemind, // 替换成你的remind_optimization_iv_icon
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 16),
              // 中间标题 + 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.remindBannerGuideTitle,
                      // 相当于 remind_optimization_tv_title
                      style: TextStyle(
                        color: AppColors.commonGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Strings.remindBannerGuideContent,
                      // 相当于 remind_optimization_tv_content
                      style: TextStyle(
                        color: AppColors.commonGray,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              // 跳转按钮
              InkWell(
                onTap: onJump,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.commonGreen, // 深绿色背景
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    Strings.remindBannerGuideBtnString, // 相当于 remind_optimization_tv_jump
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // 关闭按钮
        Positioned(
          right: 10,
          top: 0,
          child: InkWell(
            onTap: onClose,
            child: Image.asset(
              Assets.diaryImgClose, // 替换成你的 remind_optimization_iv_close
              width: 20,
              height: 20,
            ),
          ),
        )
      ],
    );
  }
}
