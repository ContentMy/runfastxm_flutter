import 'package:hive/hive.dart';
import '../../domain/models/reminder.dart';

class ReminderRepository {
  final Box<Reminder> _box = Hive.box<Reminder>('reminders');

  List<Reminder> getAll() => _box.values.toList();

  Future<void> add(Reminder reminder) => _box.put(reminder.id, reminder);

  Future<void> remove(String id) => _box.delete(id);

  Future<void> clear() => _box.clear();

  Future<void> update(Reminder reminder) => _box.put(reminder.id, reminder);
}
