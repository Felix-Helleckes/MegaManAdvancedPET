// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_chip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BattleChipAdapter extends TypeAdapter<BattleChip> {
  @override
  final int typeId = 1;

  @override
  BattleChip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BattleChip(
      id: fields[0] as String,
      name: fields[1] as String,
      damage: fields[2] as int,
      description: fields[3] as String,
      rarityIndex: fields[4] as int,
      elementIndex: fields[5] as int,
      categoryIndex: fields[6] as int,
      code: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BattleChip obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.damage)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.rarityIndex)
      ..writeByte(5)
      ..write(obj.elementIndex)
      ..writeByte(6)
      ..write(obj.categoryIndex)
      ..writeByte(7)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BattleChipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
