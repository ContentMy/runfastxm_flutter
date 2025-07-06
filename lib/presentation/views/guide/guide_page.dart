import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runfastxm_flutter/resources/strings.dart';

import '../../../resources/colors.dart';
import '../../../resources/guide_steps.dart';

class GuidePage extends StatefulWidget {
  final VoidCallback onFinish;

  const GuidePage({super.key, required this.onFinish});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int _currentIndex = 0;

  void _next() {
    final step = guideSteps[_currentIndex];
    if (step.isLast) {
      widget.onFinish();
    } else {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = guideSteps[_currentIndex];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: AppColors.commonWhite),
      child: Scaffold(
        backgroundColor: AppColors.commonWhite,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // ✅ 水平居中对齐
            children: [
              const SizedBox(height: 100),
              Image.asset(
                step.imageAsset,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 60),
              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.commonGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  step.content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2.0,
                    color: AppColors.commonGray,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: GestureDetector(
                  onTap: _next,
                  child: step.isLast
                      ? Container(
                          width: 120,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.commonGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            Strings.guideBeginString,
                            style: TextStyle(
                              color: AppColors.commonWhite,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.commonGreen,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: AppColors.commonWhite,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
