import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:runfastxm_flutter/presentation/views/reminder/remind_guide_step.dart';
import 'package:runfastxm_flutter/resources/strings.dart';

import '../../../resources/colors.dart';

class RemindGuideOverlay extends StatefulWidget {
  final GlobalKey fabKey;
  final GlobalKey menuKey;
  final VoidCallback onClose;

  const RemindGuideOverlay({
    super.key,
    required this.fabKey,
    required this.menuKey,
    required this.onClose,
  });

  @override
  State<RemindGuideOverlay> createState() => _RemindGuideOverlayState();
}

class _RemindGuideOverlayState extends State<RemindGuideOverlay> {
  RemindGuideStep? currentStep = RemindGuideStep.step1Fab;
  Rect? highlightRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateHighlight();
    });
  }

  void _updateHighlight() {
    Rect? rect;
    if (currentStep == RemindGuideStep.step1Fab) {
      rect = _getWidgetRect(widget.fabKey);
    } else if (currentStep == RemindGuideStep.step2Menu) {
      rect = _getWidgetRect(widget.menuKey);
    }
    if (mounted) {
      setState(() {
        highlightRect = rect;
      });
    }
  }

  Rect? _getWidgetRect(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final offset = renderBox.localToGlobal(Offset.zero);
      return offset & renderBox.size;
    }
    return null;
  }

  void _onNext() {
    if (currentStep == RemindGuideStep.step1Fab) {
      final rect = _getWidgetRect(widget.menuKey);
      setState(() {
        currentStep = RemindGuideStep.step2Menu;
        highlightRect = rect;
      });
    } else {
      _closeGuide();
    }
  }

  void _onClosePressed() {
    _closeGuide();
  }

  void _onHighlightTap() {
    if (currentStep == RemindGuideStep.step1Fab) {
      Fluttertoast.showToast(msg: "结束引导后即可创建提醒");
    } else if (currentStep == RemindGuideStep.step2Menu) {
      Fluttertoast.showToast(msg: "结束引导后可跳转");
    }
  }

  void _closeGuide() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep == null || highlightRect == null) {
      return const SizedBox.shrink();
    }

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {}, // absorb background taps
        child: Stack(
          children: [
            // 黑色蒙层 + 镂空
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _OverlayPainter(rect: highlightRect!),
            ),

            // 点击高亮区域
            Positioned(
              left: highlightRect!.left,
              top: highlightRect!.top,
              width: highlightRect!.width,
              height: highlightRect!.height,
              child: GestureDetector(
                onTap: _onHighlightTap,
                child: Container(color: Colors.transparent),
              ),
            ),

            ..._buildGuideContent(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGuideContent(BuildContext context) {
    if (currentStep == RemindGuideStep.step1Fab) {
      return [
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                Strings.remindGuideStepOne,
                style: TextStyle(color: AppColors.commonWhite, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _button(
                Strings.remindGuideNext,
                AppColors.commonYellow,
                AppColors.commonBlack,
                _onNext,
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 200),
                child: _button(
                  Strings.remindGuideComplete,
                  AppColors.commonGreen,
                  AppColors.commonWhite,
                  _onClosePressed,
                ),
              ),
            ],
          ),
        ),
      ];
    } else if (currentStep == RemindGuideStep.step2Menu) {
      return [
        Positioned(
          top: highlightRect!.bottom + 10,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                Strings.remindGuideStepTwo,
                style: TextStyle(color: AppColors.commonWhite, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _button(
                Strings.remindGuideNextComplete,
                AppColors.commonYellow,
                AppColors.commonBlack,
                _onClosePressed,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 200),
              child: _button(
                Strings.remindGuideComplete,
                AppColors.commonGreen,
                AppColors.commonWhite,
                _onClosePressed,
              ),
            ),
          ),
        ),
      ];
    }
    return [];
  }


  Widget _button(String text, Color bg, Color fg, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect rect;

  _OverlayPainter({required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(rect.inflate(8)) // ✅ 圆形高亮
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) {
    return oldDelegate.rect != rect;
  }
}
