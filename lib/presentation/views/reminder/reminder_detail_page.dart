import 'dart:async';
import 'package:flutter/material.dart';
import 'package:runfastxm_flutter/resources/colors.dart';
import 'package:runfastxm_flutter/resources/strings.dart';
import '../../../domain/models/reminder.dart';

class ReminderDetailPage extends StatefulWidget {
  final Reminder reminder;

  const ReminderDetailPage({super.key, required this.reminder});

  @override
  State<ReminderDetailPage> createState() => _ReminderDetailPageState();
}

class _ReminderDetailPageState extends State<ReminderDetailPage> {
  late Duration _remaining;
  Timer? _timer;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final endTime = widget.reminder.endDateTime;
    _remaining = endTime.difference(now);

    if (_remaining.isNegative) {
      _isFinished = true;
    } else {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remaining -= const Duration(seconds: 1);
        if (_remaining.inSeconds <= 0) {
          _timer?.cancel();
          _isFinished = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remaining.inMinutes.remainder(100).toString().padLeft(2, '0');
    final seconds = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.reminder.remindTitle),
        centerTitle: true,
      ),
      body: Center(
        child: _isFinished
            ? const Text(
          Strings.remindDetailEmptyContent,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FlipDigit(digit: minutes[0]),
                _FlipDigit(digit: minutes[1]),
                const SizedBox(width: 16),
                _FlipDigit(digit: seconds[0]),
                _FlipDigit(digit: seconds[1]),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(width: 60, child: Center(child: Text('分'))),
                SizedBox(width: 60, child: Center(child: Text(''))),
                SizedBox(width: 16),
                SizedBox(width: 60, child: Center(child: Text('秒'))),
                SizedBox(width: 60, child: Center(child: Text(''))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _FlipDigit extends StatelessWidget {
  final String digit;

  const _FlipDigit({required this.digit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.commonBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        digit,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppColors.commonWhite,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
