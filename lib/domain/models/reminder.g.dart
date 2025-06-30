// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 0;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      id: fields[0] as String,
      remindImg: fields[1] as String,
      remindTitle: fields[2] as String,
      remindContent: fields[3] as String,
      remindTime: fields[4] as int,
      remindStartTime: fields[5] as int,
      remindEndTime: fields[6] as int,
      remindCompleteStatus: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.remindImg)
      ..writeByte(2)
      ..write(obj.remindTitle)
      ..writeByte(3)
      ..write(obj.remindContent)
      ..writeByte(4)
      ..write(obj.remindTime)
      ..writeByte(5)
      ..write(obj.remindStartTime)
      ..writeByte(6)
      ..write(obj.remindEndTime)
      ..writeByte(7)
      ..write(obj.remindCompleteStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
