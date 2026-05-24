import 'package:hive/hive.dart';

part 'navi.g.dart';

@HiveType(typeId: 0)
class Navi extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int level;

  @HiveField(2)
  int maxHp;

  @HiveField(3)
  int currentHp;

  @HiveField(4)
  int zenny;

  @HiveField(5)
  int totalSteps;

  @HiveField(6)
  int wins;

  @HiveField(7)
  int losses;

  Navi({
    required this.name,
    this.level = 1,
    this.maxHp = 100,
    this.currentHp = 100,
    this.zenny = 0,
    this.totalSteps = 0,
    this.wins = 0,
    this.losses = 0,
  });

  /// XP required for next level (simple formula: level * 50)
  int get xpForNextLevel => level * 50;

  /// HP increases by 20 per level
  int get baseMaxHp => 100 + (level - 1) * 20;

  void levelUp() {
    level++;
    maxHp = baseMaxHp;
    currentHp = maxHp; // full heal on level-up
  }

  void heal(int amount) {
    currentHp = (currentHp + amount).clamp(0, maxHp);
  }

  void takeDamage(int amount) {
    currentHp = (currentHp - amount).clamp(0, maxHp);
  }

  bool get isAlive => currentHp > 0;

  Map<String, dynamic> toDisplayMap() => {
    'name': name,
    'level': level,
    'hp': '$currentHp / $maxHp',
    'zenny': zenny,
    'steps': totalSteps,
    'w/l': '$wins / $losses',
  };
}

