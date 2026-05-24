// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NaviAdapter extends TypeAdapter<Navi> {
  @override
  final int typeId = 0;

  @override
  Navi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Navi(
      name: fields[0] as String,
      level: fields[1] as int,
      maxHp: fields[2] as int,
      currentHp: fields[3] as int,
      zenny: fields[4] as int,
      totalSteps: fields[5] as int,
      wins: fields[6] as int,
      losses: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Navi obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.maxHp)
      ..writeByte(3)
      ..write(obj.currentHp)
      ..writeByte(4)
      ..write(obj.zenny)
      ..writeByte(5)
      ..write(obj.totalSteps)
      ..writeByte(6)
      ..write(obj.wins)
      ..writeByte(7)
      ..write(obj.losses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NaviAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
