import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../core/models/navi.dart';
import '../../core/models/battle_chip.dart';
import 'step_service.dart';

class SingleplayerProvider extends ChangeNotifier {
  // Initialize with a safe default so UI can build before Hive init completes
  Navi _navi = Navi(name: 'Player');
  List<BattleChip> _chips = [];
  bool _encounterPending = false;
  int _steps = 0;

  Navi get navi => _navi;
  List<BattleChip> get chips => List.unmodifiable(_chips);
  bool get encounterPending => _encounterPending;
  int get steps => _steps;

  int get stepsToNextEncounter {
    const trigger = StepService.stepsPerEncounter;
    return trigger - (_steps % trigger);
  }

  Future<void> init() async {
    final naviBox = Hive.box<Navi>('navi');
    final chipBox = Hive.box<BattleChip>('chips');

    // First launch – create default Navi and starter chips
    if (naviBox.isEmpty) {
      final defaultNavi = Navi(name: 'MegaMan');
      await naviBox.add(defaultNavi);
      for (final chip in BattleChip.starterDeck) {
        await chipBox.add(chip);
      }
    }

    _navi = naviBox.getAt(0)!;
    _chips = chipBox.values.toList();
    _steps = StepService.currentSteps;

    // Listen for new steps
    StepService.stepStream.listen((steps) {
      _steps = steps;
      notifyListeners();
    });

    // Listen for encounter triggers from StepService
    StepService.onEncounterTriggered = () {
      _encounterPending = true;
      notifyListeners();
    };

    notifyListeners();
  }

  void clearEncounter() {
    _encounterPending = false;
    notifyListeners();
  }

  /// Called after winning a fight – rewards Zenny and potentially a chip drop
  Future<void> claimVictoryReward({required int zennyReward}) async {
    _navi.zenny += zennyReward;
    _navi.wins++;
    await _navi.save();

    // Chip drop chance by rarity
    final roll = Random().nextDouble();
    BattleChip? dropped;
    if (roll < 0.05) {
      dropped = _randomChipByRarity(ChipRarity.giga);
    } else if (roll < 0.20) {
      dropped = _randomChipByRarity(ChipRarity.mega);
    } else if (roll < 0.65) {
      dropped = _randomChipByRarity(ChipRarity.standard);
    }

    if (dropped != null) {
      final chipBox = Hive.box<BattleChip>('chips');
      await chipBox.add(dropped);
      _chips = chipBox.values.toList();
    }

    notifyListeners();
  }

  BattleChip _randomChipByRarity(ChipRarity rarity) {
    final pool = BattleChip.fullCatalog
        .where((c) => c.rarity == rarity)
        .toList();
    return pool[Random().nextInt(pool.length)];
  }

  Future<void> recordLoss() async {
    _navi.losses++;
    await _navi.save();
    notifyListeners();
  }

  /// Delete a chip from the folder (for trading)
  Future<void> removeChip(int index) async {
    final chip = _chips[index];
    await chip.delete();
    _chips = Hive.box<BattleChip>('chips').values.toList();
    notifyListeners();
  }

  /// Simulates steps (debug/demo button in UI)
  void simulateSteps(int count) {
    StepService.addSimulatedSteps(count);
  }
}
