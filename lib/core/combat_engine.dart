import 'dart:math';
import 'models/battle_chip.dart';

class CombatResult {
  final int playerHp;
  final int enemyHp;
  final String log;
  final bool victory;

  CombatResult({required this.playerHp, required this.enemyHp, required this.log, required this.victory});
}

/// Simple deterministic resolver for a single player attack round.
CombatResult resolvePlayerRound({
  required int playerHp,
  required int playerMaxHp,
  required int enemyHp,
  required int enemyMaxHp,
  required BattleChip playerChip,
  int nextAttackBonus = 0,
}) {
  final rng = Random(12345); // deterministic seed for tests
  var log = <String>[];
  var pHp = playerHp;
  var eHp = enemyHp;

  // Player action
  if (playerChip.category == ChipCategory.heal) {
    pHp = min(playerMaxHp, pHp + (-playerChip.damage));
    log.add('${playerChip.name} healed ${-playerChip.damage} HP');
  } else if (playerChip.category == ChipCategory.defense) {
    log.add('${playerChip.name} used to block');
    // blocking handled in higher-level logic
  } else if (playerChip.category == ChipCategory.support) {
    log.add('${playerChip.name} buffed next attack by ${playerChip.damage}');
  } else {
    final dmg = playerChip.damage + nextAttackBonus;
    eHp = max(0, eHp - dmg);
    log.add('${playerChip.name} dealt $dmg damage');
  }

  // Enemy retaliates with a deterministic damage if alive
  if (eHp > 0) {
    final enemyDmg = 10 + rng.nextInt(15);
    pHp = max(0, pHp - enemyDmg);
    log.add('Enemy dealt $enemyDmg damage');
  }

  final victory = eHp <= 0 && pHp > 0;

  return CombatResult(playerHp: pHp, enemyHp: eHp, log: log.join('\n'), victory: victory);
}
