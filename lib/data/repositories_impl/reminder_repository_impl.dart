import 'package:hive/hive.dart';
import '../../domain/models/reminder.dart';

///CURD写法，没有使用async/await，直接 return Future，相对较为简洁，但如果有内部处理异常的需求，就无法满足了，如果想要try/catch，就需要写成其他两个repository的业务声明形式
class ReminderRepository {
  final Box<Reminder> _box = Hive.box<Reminder>('reminders');

  List<Reminder> getAll() => _box.values.toList();

  Future<void> add(Reminder reminder) => _box.put(reminder.id, reminder);

  Future<void> remove(String id) => _box.delete(id);

  Future<void> clear() => _box.clear();

  Future<void> update(Reminder reminder) => _box.put(reminder.id, reminder);
}
