// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_check_in.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalCheckInAdapter extends TypeAdapter<GoalCheckIn> {
  @override
  final int typeId = 3;

  @override
  GoalCheckIn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalCheckIn(
      id: fields[0] as String?,
      goalId: fields[1] as String,
      checkInDate: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GoalCheckIn obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalId)
      ..writeByte(2)
      ..write(obj.checkInDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalCheckInAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
