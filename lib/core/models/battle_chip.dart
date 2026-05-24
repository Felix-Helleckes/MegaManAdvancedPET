import 'package:hive/hive.dart';
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
  int rarityIndex; // ChipRarity.index

  @HiveField(5)
  int elementIndex; // ChipElement.index

  @HiveField(6)
  int categoryIndex; // ChipCategory.index

  @HiveField(7)
  String code; // A-Z, like original game

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

  ChipRarity get rarity => ChipRarity.values[rarityIndex];
  ChipElement get element => ChipElement.values[elementIndex];
  ChipCategory get category => ChipCategory.values[categoryIndex];

  Color get rarityColor {
    switch (rarity) {
      case ChipRarity.standard: return PetTheme.rarityStandard;
      case ChipRarity.mega:     return PetTheme.rarityMega;
      case ChipRarity.giga:     return PetTheme.rarityGiga;
    }
  }

  String get rarityLabel {
    switch (rarity) {
      case ChipRarity.standard: return 'STD';
      case ChipRarity.mega:     return 'MEGA';
      case ChipRarity.giga:     return 'GIGA';
    }
  }

  String get elementEmoji {
    switch (element) {
      case ChipElement.normal: return '⚪';
      case ChipElement.fire:   return '🔥';
      case ChipElement.aqua:   return '💧';
      case ChipElement.elec:   return '⚡';
      case ChipElement.wood:   return '🌿';
    }
  }

  /// Optional URL to a representative image for this chip.
  /// Uses the Miraheze wiki `Special:FilePath` route to serve raw image files.
  /// Returns null when no known image mapping exists for the chip id.
  String? get imageUrl {
    switch (id) {
      case 'chip_001': return 'assets/images/BattleChip001.png';
      case 'chip_002': return 'assets/images/BattleChip002.png';
      case 'chip_003': return 'assets/images/BattleChip003.png';
      case 'chip_004': return 'assets/images/BattleChip004.png';
      case 'chip_005': return 'assets/images/BattleChip005.png';
      case 'chip_006': return 'assets/images/BattleChip006.png';
      case 'chip_007': return 'assets/images/BattleChip007.png';
      case 'chip_008': return 'assets/images/BattleChip008.png';
      case 'chip_009': return 'assets/images/BattleChip009.png';
      case 'chip_010': return 'assets/images/BattleChip010.png';
      case 'chip_011': return 'assets/images/BattleChip011.png';
      case 'chip_012': return 'assets/images/BattleChip012.png';
      // add more mappings here as desired/available from the Lastenheft wiki
      default: return null;
    }
  }

  // ── Starter chip pool ─────────────────────────────────────────────────────
  static List<BattleChip> get starterDeck => [
    BattleChip(id: 'cannon_a',   name: 'Cannon',    damage: 40,  description: 'Fires a powerful shot.', rarityIndex: 0, elementIndex: 0, categoryIndex: 0, code: 'A'),
    BattleChip(id: 'sword_b',    name: 'Sword',     damage: 80,  description: 'Slashes with a blade.',  rarityIndex: 0, elementIndex: 0, categoryIndex: 0, code: 'B'),
    BattleChip(id: 'guard_c',    name: 'Guard',     damage: 0,   description: 'Blocks one attack.',    rarityIndex: 0, elementIndex: 0, categoryIndex: 1, code: 'C'),
    BattleChip(id: 'recov10_d',  name: 'Recov10',   damage: -10, description: 'Restores 10 HP.',       rarityIndex: 0, elementIndex: 0, categoryIndex: 2, code: 'D'),
    BattleChip(id: 'cannon_a2',  name: 'Cannon',    damage: 40,  description: 'Fires a powerful shot.', rarityIndex: 0, elementIndex: 0, categoryIndex: 0, code: 'A'),
  ];

  static List<BattleChip> get fullCatalog => [
    ...starterDeck,
    // Attack Chips
    BattleChip(id: 'firesword_e', name: 'FireSword', damage: 130, description: 'Blazing blade attack.', rarityIndex: 1, elementIndex: 1, categoryIndex: 0, code: 'E'),
    BattleChip(id: 'aquaneed_f',  name: 'AquaNeedl', damage: 90,  description: 'Three water needles.', rarityIndex: 1, elementIndex: 2, categoryIndex: 0, code: 'F'),
    BattleChip(id: 'thunder_g',   name: 'Thunder',   damage: 80,  description: 'Lightning strike. Stuns.',    rarityIndex: 1, elementIndex: 3, categoryIndex: 0, code: 'G'),
    BattleChip(id: 'plantman_h',  name: 'PlantMan',  damage: 100, description: 'Vine trap attack.',    rarityIndex: 1, elementIndex: 4, categoryIndex: 0, code: 'H'),
    BattleChip(id: 'megacannon_j',name: 'MegaCannon', damage: 200, description: 'Massive energy blast.', rarityIndex: 2, elementIndex: 0, categoryIndex: 0, code: 'J'),
    BattleChip(id: 'protoatk_k', name: 'ProtoAtk',  damage: 180, description: "ProtoMan's blade.",    rarityIndex: 2, elementIndex: 0, categoryIndex: 0, code: 'K'),
    
    // Recovery Chips
    BattleChip(id: 'recov30_r',   name: 'Recov30',   damage: -30, description: 'Restores 30 HP.',      rarityIndex: 0, elementIndex: 0, categoryIndex: 2, code: 'A'),
    BattleChip(id: 'recov80_i',   name: 'Recov80',   damage: -80, description: 'Restores 80 HP.',      rarityIndex: 1, elementIndex: 0, categoryIndex: 2, code: 'I'),
    BattleChip(id: 'recov150_s',  name: 'Recov150',  damage: -150, description: 'Restores 150 HP.',    rarityIndex: 1, elementIndex: 0, categoryIndex: 2, code: 'R'),
    BattleChip(id: 'recov300_t',  name: 'Recov300',  damage: -300, description: 'Restores 300 HP.',    rarityIndex: 2, elementIndex: 0, categoryIndex: 2, code: 'S'),
    
    // Support/Buff Chips
    BattleChip(id: 'atkplus10_l', name: 'Atk+10', damage: 10, description: 'Adds 10 damage to next attack.', rarityIndex: 0, elementIndex: 0, categoryIndex: 3, code: 'L'),
    BattleChip(id: 'atkplus30_m', name: 'Atk+30', damage: 30, description: 'Adds 30 damage to next attack.', rarityIndex: 1, elementIndex: 0, categoryIndex: 3, code: 'M'),
    BattleChip(id: 'areagrab_n', name: 'AreaGrab', damage: 0, description: 'Steals opponent area. Stuns.', rarityIndex: 0, elementIndex: 0, categoryIndex: 3, code: 'N'),
    
    // Defensive Chips
    BattleChip(id: 'barrier_o', name: 'Barrier', damage: 0, description: 'Nullifies one attack.', rarityIndex: 0, elementIndex: 0, categoryIndex: 1, code: 'O'),
    BattleChip(id: 'shield_p', name: 'Shield', damage: 0, description: 'Blocks attacks if timed right.', rarityIndex: 0, elementIndex: 0, categoryIndex: 1, code: 'P'),
    
    // Status/Stun Chips
    BattleChip(id: 'flashman_q', name: 'FlashMan', damage: 50, description: 'Flashes and stuns the opponent.', rarityIndex: 1, elementIndex: 3, categoryIndex: 0, code: 'Q'),
    BattleChip(id: 'roll_r', name: 'Roll', damage: 60, description: 'Attacks and heals you.', rarityIndex: 2, elementIndex: 0, categoryIndex: 0, code: 'R'),
    BattleChip(id: 'gutsman_s', name: 'GutsMan', damage: 100, description: 'Cracks panels and damages.', rarityIndex: 2, elementIndex: 0, categoryIndex: 0, code: 'G'),

    // Parsed from Wiki
    BattleChip(id: 'chip_001', name: 'Cannon', damage: 40, description: 'A standard Cannon.', rarityIndex: 0, elementIndex: 0, categoryIndex: 0, code: 'B'),
    BattleChip(id: 'chip_002', name: 'HiCannon', damage: 80, description: 'A strong Cannon.', rarityIndex: 0, elementIndex: 0, categoryIndex: 0, code: 'C'),
    BattleChip(id: 'chip_003', name: 'M-Cannon', damage: 100, description: 'A massive Cannon.', rarityIndex: 0, elementIndex: 0, categoryIndex: 0, code: 'D'),
    BattleChip(id: 'chip_004', name: 'AirShot', damage: 40, description: 'Pushes the opponent.', rarityIndex: 0, elementIndex: 0, categoryIndex: 0, code: 'E'),
    BattleChip(id: 'chip_005', name: 'Blizzard', damage: 80, description: 'Snow storm attack.', rarityIndex: 0, elementIndex: 2, categoryIndex: 0, code: 'F'),
    BattleChip(id: 'chip_006', name: 'HeatBrth', damage: 80, description: 'Fire breath attack.', rarityIndex: 0, elementIndex: 1, categoryIndex: 0, code: 'G'),
    BattleChip(id: 'chip_007', name: 'Silence', damage: 20, description: 'Silences opponent.', rarityIndex: 0, elementIndex: 0, categoryIndex: 0, code: 'H'),
    BattleChip(id: 'chip_009', name: 'WideShot1', damage: 60, description: 'Wide water attack.', rarityIndex: 0, elementIndex: 2, categoryIndex: 0, code: 'J'),
    BattleChip(id: 'chip_010', name: 'WideShot2', damage: 80, description: 'Wider water attack.', rarityIndex: 0, elementIndex: 2, categoryIndex: 0, code: 'K'),
    BattleChip(id: 'chip_011', name: 'WideShot3', damage: 100, description: 'Widest water attack.', rarityIndex: 0, elementIndex: 2, categoryIndex: 0, code: 'L'),
    BattleChip(id: 'chip_012', name: 'FlameLine1', damage: 80, description: 'Line of fire.', rarityIndex: 0, elementIndex: 1, categoryIndex: 0, code: 'M'),
  ];
}

