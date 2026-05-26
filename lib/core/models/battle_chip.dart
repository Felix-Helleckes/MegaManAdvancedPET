import 'package:hive/hive.dart';
import 'battle_chip_data.dart';
import 'package:flutter/material.dart';
import '../../shared/theme/pet_theme.dart';
part 'battle_chip.g.dart';

enum ChipRarity { standard, mega, giga }
enum ChipElement { normal, fire, aqua, elec, wood }
enum ChipCategory { attack, defense, heal, support }

@HiveType(typeId: 1)
class BattleChip extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int damage;

  @HiveField(3)
  String description;

  @HiveField(4)
  int rarityIndex;

  @HiveField(5)
  int elementIndex;

  @HiveField(6)
  int categoryIndex;

  @HiveField(7)
  String code;

  BattleChip({
    required this.id,
    required this.name,
    required this.damage,
    required this.description,
    required this.rarityIndex,
    required this.elementIndex,
    required this.categoryIndex,
    required this.code,
  });

  ChipRarity get rarity => ChipRarity.values[rarityIndex.clamp(0, ChipRarity.values.length - 1)];
  ChipElement get element => ChipElement.values[elementIndex.clamp(0, ChipElement.values.length - 1)];
  ChipCategory get category => ChipCategory.values[categoryIndex.clamp(0, ChipCategory.values.length - 1)];

  String get elementEmoji {
    switch (element) {
      case ChipElement.fire:
        return '🔥';
      case ChipElement.aqua:
        return '💧';
      case ChipElement.elec:
        return '⚡';
      case ChipElement.wood:
        return '🌿';
      default:
        return '•';
    }
  }

  Color get rarityColor {
    switch (rarity) {
      case ChipRarity.mega:
        return PetTheme.rarityMega;
      case ChipRarity.giga:
        return PetTheme.rarityGiga;
      case ChipRarity.standard:
        return PetTheme.rarityStandard;
    }
  }

  String get typeLabel {
    switch (category) {
      case ChipCategory.attack:
        return 'Attack';
      case ChipCategory.defense:
        return 'Defense';
      case ChipCategory.heal:
        return 'Heal';
      case ChipCategory.support:
        return 'Support';
    }
  }

  String get classLabel {
    switch (rarity) {
      case ChipRarity.standard:
        return 'STD';
      case ChipRarity.mega:
        return 'MEGA';
      case ChipRarity.giga:
        return 'GIGA';
    }
  }

  String get elementLabel {
    switch (element) {
      case ChipElement.fire:
        return 'Fire';
      case ChipElement.aqua:
        return 'Aqua';
      case ChipElement.elec:
        return 'Elec';
      case ChipElement.wood:
        return 'Wood';
      case ChipElement.normal:
        return 'Neutral';
    }
  }

  int get atValue => damage;

  String? get imageUrl => null;

  // Prefer generated metadata when available (tools may emit battle_chip_data.dart)
  // A small placeholder generator ensures compile-time availability.
  static List<BattleChip> get starterDeck => [
        BattleChip(
          id: 'chip_001',
          name: 'Chip 001',
          damage: 0,
          description: 'Starter',
          rarityIndex: 0,
          elementIndex: 0,
          categoryIndex: 0,
          code: '?',
        ),
      ];

  static List<BattleChip> get fullCatalog {
    // Prefer generated metadata when available (tools may emit battle_chip_data.dart)
    try {
      // `generatedFullCatalog` is produced by tools/generate_chip_data_from_assets.py or fetch script.
      if (generatedFullCatalog.isNotEmpty) return generatedFullCatalog;
    } catch (_) {}
    // Fallback: placeholders for 1..320
    return List.generate(320, (i) {
      final id = 'chip_${(i + 1).toString().padLeft(3, '0')}';
      return BattleChip(
        id: id,
        name: 'Chip ${ (i + 1).toString().padLeft(3, '0') }',
        damage: 0,
        description: 'Placeholder',
        rarityIndex: 0,
        elementIndex: 0,
        categoryIndex: 0,
        code: '?',
      );
    });
  }
}
