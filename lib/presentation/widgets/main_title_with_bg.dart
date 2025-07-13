import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class MainTitleWithBg extends StatelessWidget {
  final String title;

  const MainTitleWithBg({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        // 背景条
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.commonGreen,
                  AppColors.commonTransparent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(100),
              ),
            ),
          ),
        ),
        // 标题文字
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'ZihunShiguang',
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}


