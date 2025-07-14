import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class SettingItem extends StatelessWidget {
  final String iconAsset; // 左侧 asset 图片
  final String title;
  final String? status;
  final String arrowAsset; // 右侧箭头图片
  final VoidCallback? onTap;
  final Color backgroundColor;

  const SettingItem({
    super.key,
    required this.iconAsset,
    required this.title,
    this.status,
    required this.arrowAsset,
    this.onTap,
    this.backgroundColor = AppColors.commonGreenMidNextLight, // 默认绿色背景
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Image.asset(iconAsset, width: 40, height: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (status != null) ...[
              Text(
                status!,
                style: const TextStyle(fontSize: 14, color: AppColors.commonGreenMid),
              ),
            ],
            const SizedBox(width: 4),
            Image.asset(arrowAsset, width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}
