import 'dart:async';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../core/models/battle_chip.dart';
import '../../core/models/navi.dart';
import '../bluetooth/ble_provider.dart';

enum CombatPhase { selectChip, slashReady, animating, result, victory, defeat }

class CombatUnit {
  final String name;
  int hp;
  final int maxHp;

  CombatUnit({required this.name, required this.hp, required this.maxHp});

  bool get isAlive => hp > 0;
  double get hpFrac => (hp / maxHp).clamp(0.0, 1.0);
  void takeDamage(int d) => hp = (hp - d).clamp(0, maxHp);
  void heal(int h) => hp = (hp + h).clamp(0, maxHp);
}

class CombatProvider extends ChangeNotifier {
  CombatPhase _phase = CombatPhase.selectChip;
  CombatUnit? _player;
  CombatUnit? _enemy;
  BattleChip? _selectedChip;
  String _log = '';
  int _zennyReward = 0;
  BattleChip? _chipReward;
  bool _slashDetected = false;
  int _nextAttackBonus = 0;

  StreamSubscription? _accelSub;
  StreamSubscription<Map<String, dynamic>>? _bleSub;
  DateTime _lastSlash = DateTime.now();

  CombatPhase get phase => _phase;
  CombatUnit? get player => _player;
  CombatUnit? get enemy => _enemy;
  BattleChip? get selectedChip => _selectedChip;
  String get log => _log;
  int get zennyReward => _zennyReward;
  BattleChip? get chipReward => _chipReward;
  bool get slashDetected => _slashDetected;

  void startCombat({
    required Navi playerNavi,
    required List<BattleChip> playerChips,
    required bool isVirus,
  }) {
    _player = CombatUnit(
      name: playerNavi.name,
      hp: playerNavi.currentHp,
      maxHp: playerNavi.maxHp,
    );

    final virusTypes = ['MetalVirus', 'FireVirus', 'AquaVirus', 'ElecVirus'];
    final enemyName = isVirus
        ? virusTypes[Random().nextInt(virusTypes.length)]
        : 'Rival Navi';
    final enemyHp = 50 + Random().nextInt(80);

    _enemy = CombatUnit(name: enemyName, hp: enemyHp, maxHp: enemyHp);
    _phase = CombatPhase.selectChip;
    _selectedChip = null;
    _log = 'Select a chip to battle!';
    _zennyReward = 20 + Random().nextInt(40);
    _chipReward = null;
    _slashDetected = false;
    _nextAttackBonus = 0;

    _startSlashDetection();
    notifyListeners();
  }

  /// Start a PvP combat using an external `BleProvider`.
  void startPvpWith(BleProvider ble, {required Navi playerNavi, required List<BattleChip> playerChips}) {
    // subscribe to incoming messages
    _bleSub?.cancel();
    _bleSub = ble.messageStream.listen((msg) {
      final t = msg['type'] as String?;
      if (t == 'chip_select') {
        final idx = msg['chipIndex'] as int?;
        _log = 'Opponent selected chip #${idx ?? -1}';
        notifyListeners();
      } else if (t == 'pvp_start') {
        // handshake completed
        _log = 'PVP Start signal received';
        notifyListeners();
      }
    });
    // Send a request to start PvP
    ble.sendMessage({'type': 'pvp_request', 'name': playerNavi.name, 'level': playerNavi.level});
  }

  void selectChip(BattleChip chip) {
    if (_phase != CombatPhase.selectChip) return;
    _selectedChip = chip;
    _phase = CombatPhase.slashReady;
    _log = 'Chip loaded! SLASH to attack!';
    notifyListeners();
  }

  void _startSlashDetection() {
    _accelSub?.cancel();
    // Avoid subscribing to accelerometer on desktop/web where plugin may be missing
    if (kIsWeb || (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // No sensors available — rely on tap-based attack instead.
      return;
    }

    _accelSub = accelerometerEventStream().listen((event) {
      if (_phase != CombatPhase.slashReady) return;
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      final now = DateTime.now();
      if (magnitude > 22 &&
          now.difference(_lastSlash).inMilliseconds > 800) {
        _lastSlash = now;
        _onSlashDetected();
      }
    });
  }

  void _onSlashDetected() {
    _slashDetected = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 300), () => executeAttack());
  }

  /// Also callable from a tap button (for devices without sensors or testing)
  void executeAttack() {
    if (_phase != CombatPhase.slashReady || _selectedChip == null) return;
    _phase = CombatPhase.animating;
    final chip = _selectedChip!;

    bool stun = chip.description.toLowerCase().contains('stun') || chip.description.toLowerCase().contains('silence');

    if (chip.category == ChipCategory.heal) {
      _player!.heal(-chip.damage); // damage is negative for heals
      _log = '${chip.name}! Restored ${-chip.damage} HP!';
    } else if (chip.category == ChipCategory.defense) {
      // Guard: blocks next enemy attack
      _log = '${chip.name}! Shield active!';
      _resolveRound(blockedEnemy: true);
      return;
    } else if (chip.category == ChipCategory.support) {
      _nextAttackBonus += chip.damage;
      _log = '${chip.name}! Next attack +${chip.damage} DMG!';
      _resolveRound(blockedEnemy: stun);
      return;
    } else {
      final dmg = chip.damage + _nextAttackBonus;
      _nextAttackBonus = 0;
      _enemy!.takeDamage(dmg);
      _log = '${chip.name}! $dmg DMG to ${_enemy!.name}!';
    }

    if (stun) {
      _log += '\n${_enemy!.name} is paralyzed!';
      _resolveRound(blockedEnemy: true);
    } else {
      _resolveRound(blockedEnemy: false);
    }
  }

  void _resolveRound({required bool blockedEnemy}) {
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!_enemy!.isAlive) {
        _phase = CombatPhase.victory;
        _log = 'VICTORY! +$_zennyReward ZENNY';
        _accelSub?.cancel();
        notifyListeners();
        return;
      }

      if (!blockedEnemy) {
        final enemyDmg = 10 + Random().nextInt(20);
        _player!.takeDamage(enemyDmg);
        _log += '\n${_enemy!.name} attacks! $enemyDmg DMG!';
      }

      if (!_player!.isAlive) {
        _phase = CombatPhase.defeat;
        _log = 'DEFEAT...';
        _accelSub?.cancel();
        notifyListeners();
        return;
      }

      _phase = CombatPhase.selectChip;
      _selectedChip = null;
      _slashDetected = false;
      notifyListeners();
    });
  }

  void reset() {
    _accelSub?.cancel();
    _phase = CombatPhase.selectChip;
    _selectedChip = null;
    _log = '';
    _slashDetected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }
}
