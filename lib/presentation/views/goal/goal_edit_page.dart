import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runfastxm_flutter/domain/models/goal.dart';
import 'package:runfastxm_flutter/resources/colors.dart';
import 'package:runfastxm_flutter/resources/strings.dart';

import '../../../resources/assets.dart';

class GoalEditPage extends StatefulWidget {
  final Goal? goal;

  const GoalEditPage({super.key, this.goal});

  @override
  State<GoalEditPage> createState() => _GoalEditPageState();
}

class _GoalEditPageState extends State<GoalEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int _selectedIconIndex = 0;
  int _startTime = DateTime.now().millisecondsSinceEpoch;
  int? _endTime;
  int _selectedStatusIndex = 0;
  bool _needRemind = false;

  final icons = Assets.goalIconList;

  final List<String> _statuses = ['暂不设置', '早晨', '上午', '中午', '下午', '晚上', '深夜'];

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart
        ? DateTime.fromMillisecondsSinceEpoch(_startTime)
        : (_endTime != null
              ? DateTime.fromMillisecondsSinceEpoch(_endTime!)
              : DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked.millisecondsSinceEpoch;
          // 如果结束时间早于开始时间，重置结束时间
          if (_endTime != null && _endTime! < _startTime) {
            _endTime = null;
          }
        } else {
          _endTime = picked.millisecondsSinceEpoch;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.goal != null) {
      final goal = widget.goal!;
      _titleController.text = goal.title;
      _contentController.text = goal.content;
      _selectedIconIndex = goal.iconIndex;
      _startTime = goal.startTime;
      _endTime = goal.endTime == 0 ? null : goal.endTime;
      _selectedStatusIndex = goal.statusIndex;
      _needRemind = goal.needRemind;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(widget.goal != null ? '编辑目标' : '新建目标'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
              child: Image.asset(
                icons[_selectedIconIndex],
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(///想要修改为自适应hint宽度，跟随输入文本增加宽度增加，然后达到最大宽度换行，但是flutter目前的直接方案不支持，后续尝试进行优化
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.grey[200],
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 32,
              ),
              child: TextField(
                controller: _titleController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: Strings.goalCreateTitleHint,
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(
            Assets.goalSmallIconChoose,
            Strings.goalCreateIconChoosePrompt,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: icons.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final selected = index == _selectedIconIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIconIndex = index);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: Image.asset(icons[index], fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildDatePicker(
            Assets.goalSmallIconStartTime,
            Strings.goalCreateStartTimePrompt,
            DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.fromMillisecondsSinceEpoch(_startTime)),
            () => _pickDate(isStart: true),
          ),
          const SizedBox(height: 16),
          _buildDatePicker(
            Assets.goalSmallIconEndTime,
            Strings.goalCreateEndTimePrompt,
            _endTime != null
                ? DateFormat(
                    'yyyy-MM-dd',
                  ).format(DateTime.fromMillisecondsSinceEpoch(_endTime!))
                : Strings.goalCreateEndTimeDefault,
            () => _pickDate(isStart: false),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle(
                Assets.goalSmallIconCalendar,
                Strings.goalCreateStatusChoosePrompt,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  _statuses[_selectedStatusIndex],
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_statuses.length, (index) {
                final selected = index == _selectedStatusIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedStatusIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.commonBlack : AppColors.commonGrayLight,
                        border: Border.all(color: AppColors.commonBlack),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _statuses[index],
                        style: TextStyle(
                          color: selected ? AppColors.commonWhite : AppColors.commonBlack,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle(
            Assets.goalSmallIconRecord,
            Strings.goalCreateContentPrompt,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[200],
            child: TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: Strings.goalCreateContentHint,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Row(
          //   children: [
          //     const Icon(Icons.notifications, size: 20, color: Colors.black),
          //     const SizedBox(width: 8),
          //     const Text('开启提醒', style: TextStyle(fontSize: 16)),
          //     const Spacer(),
          //     Switch(
          //       value: _needRemind,
          //       onChanged: (value) => setState(() => _needRemind = value),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveGoal,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(Strings.saveString, style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _saveGoal() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入目标名称')));
      return;
    }

    final goal = Goal(
      id: widget.goal?.id,
      iconIndex: _selectedIconIndex,
      title: _titleController.text,
      startTime: _startTime,
      endTime: _endTime ?? 0,
      statusIndex: _selectedStatusIndex,
      content: _contentController.text,
      needRemind: _needRemind,
    );

    Navigator.pop(context, goal);
  }

  Widget _buildSectionTitle(String assetPath, String text) {
    return Row(
      children: [
        Image.asset(assetPath, width: 20, height: 20, fit: BoxFit.contain),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    String assetPath,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(assetPath, width: 20, height: 20, fit: BoxFit.contain),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          Text(value, style: const TextStyle(color: AppColors.commonGray)),
          const Icon(Icons.chevron_right, color: AppColors.commonGray),
        ],
      ),
    );
  }
}
