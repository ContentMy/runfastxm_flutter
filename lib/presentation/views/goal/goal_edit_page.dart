import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runfastxm_flutter/domain/models/goal.dart';

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

  final List<IconData> _icons = [
    Icons.star, Icons.book, Icons.fitness_center, Icons.music_note,
    Icons.palette, Icons.code, Icons.language, Icons.camera_alt, Icons.travel_explore
  ];

  final List<String> _statuses = ['暂不设置', '早晨', '上午', '中午', '下午', '晚上', '深夜'];

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart
        ? DateTime.fromMillisecondsSinceEpoch(_startTime)
        : (_endTime != null ? DateTime.fromMillisecondsSinceEpoch(_endTime!) : DateTime.now());

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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
              child: Icon(_icons[_selectedIconIndex], size: 40),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.grey[200],
              child: TextField(
                controller: _titleController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '请输入目标的名称',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(Icons.image, '请挑选目标的图标：'),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _icons.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final selected = index == _selectedIconIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIconIndex = index);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: Icon(_icons[index], size: 30),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildDatePicker(
              Icons.calendar_today,
              '目标开始时间：',
              DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(_startTime)),
                  () => _pickDate(isStart: true)
          ),
          const SizedBox(height: 16),
          _buildDatePicker(
              Icons.date_range,
              '目标结束时间：',
              _endTime != null
                  ? DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(_endTime!))
                  : '永不结束',
                  () => _pickDate(isStart: false)
          ),
          const SizedBox(height: 16),
          _buildSectionTitle(Icons.access_time, '目标状态：'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _statuses[_selectedStatusIndex],
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_statuses.length, (index) {
              final selected = index == _selectedStatusIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedStatusIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? Colors.blue : Colors.grey[200],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _statuses[index],
                    style: TextStyle(color: selected ? Colors.white : Colors.black),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(Icons.edit_note, '目标备注：'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[200],
            child: TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '输入目标描述...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.notifications, size: 20, color: Colors.black),
              const SizedBox(width: 8),
              const Text('开启提醒', style: TextStyle(fontSize: 16)),
              const Spacer(),
              Switch(
                value: _needRemind,
                onChanged: (value) => setState(() => _needRemind = value),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveGoal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('保存', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _saveGoal() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入目标名称')),
      );
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

  Widget _buildSectionTitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDatePicker(IconData icon, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Text(value, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}