import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../resources/assets.dart';
import '../../../resources/strings.dart';

class ReminderInputSheet extends StatefulWidget {
  final Function(String content, Duration duration) onSubmit;

  const ReminderInputSheet({super.key, required this.onSubmit});

  @override
  State<ReminderInputSheet> createState() => _ReminderInputSheetState();
}

class _ReminderInputSheetState extends State<ReminderInputSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;

  final List<Duration> _presetDurations = [
    Duration(minutes: 5),
    Duration(minutes: 10),
    Duration(minutes: 15),
    Duration(minutes: 20),
    Duration(minutes: 25),
    Duration(minutes: 30),
    Duration(minutes: 45),
    Duration(hours: 1),
  ];

  Duration _selectedDuration = Duration(minutes: 5);

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      Fluttertoast.showToast(
        msg: Strings.reminderCreateNullToast,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14,
      );
      return;
    }
    widget.onSubmit(text, _selectedDuration);
    Navigator.of(context).pop(); // 收起弹窗
  }


  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
    // 延迟激活焦点，让弹窗先渲染完毕
    Future.delayed(const Duration(milliseconds: 200), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(), // 点击空白收起键盘
      child: Wrap(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom + 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左侧内容区域
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 高度随内容变化
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: Strings.reminderCreateEmptyTitle,
                          border: InputBorder.none, // 去掉边框
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(Strings.reminderCreateTimePrompt),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _presetDurations.length,
                          itemBuilder: (context, index) {
                            final duration = _presetDurations[index];
                            final isSelected = duration == _selectedDuration;
                            final label = duration.inMinutes < 60
                                ? '${duration.inMinutes}分钟'
                                : '${duration.inHours}小时';

                            return GestureDetector(
                              onTap: () =>
                                  setState(() {
                                    _selectedDuration = duration;
                                  }),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // 右侧发送按钮，垂直居中
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Image.asset(_hasText
                          ? Assets.reminderImgSend
                          : Assets.reminderImgSendDefault, width: 24, height:
                          24),
                      onPressed: _submit,
                      tooltip: '发送',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
