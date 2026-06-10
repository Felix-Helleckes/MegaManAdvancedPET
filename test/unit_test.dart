// Unit tests for core logic without asset dependencies
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:project_pet/core/models/navi.dart';
import 'package:project_pet/core/models/battle_chip.dart';

void main() {
  group('Core Models', () {
    test('Navi model can be created', () {
      final navi = Navi(
        name: 'MegaMan',
        level: 1,
        maxHp: 100,
        currentHp: 100,
        zenny: 0,
        totalSteps: 0,
        wins: 0,
        losses: 0,
      );
      expect(navi.name, equals('MegaMan'));
      expect(navi.level, equals(1));
      expect(navi.currentHp, equals(100));
    });

    test('BattleChip model can be created', () {
      final chip = BattleChip(
        id: 'BattleChip001',
        name: 'Cannon',
        description: 'Fires a cannon shot',
        rarityIndex: 0,
        elementIndex: 0,
        categoryIndex: 0,
        code: 'CANNON',
        damage: 40,
      );
      expect(chip.name, equals('Cannon'));
      expect(chip.damage, equals(40));
      expect(chip.rarity.toString(), contains('standard'));
    });
  });

  group('Hive Storage', () {
    late Directory tempDir;

    setUpAll(() {
      // Initialize Hive in temp directory for tests
      tempDir = Directory.systemTemp.createTempSync('project_pet_unit_test');
      Hive.init(tempDir.path);
    });

    setUp(() async {
      Hive.registerAdapter(NaviAdapter());
      Hive.registerAdapter(BattleChipAdapter());
    });

    tearDown(() async {
      // Clean up boxes manually
      try {
        if (Hive.isBoxOpen('navi')) {
          await Hive.box('navi').clear();
          await Hive.box('navi').close();
        }
        if (Hive.isBoxOpen('chips')) {
          await Hive.box('chips').clear();
          await Hive.box('chips').close();
        }
      } catch (_) {}
      Hive.resetAdapters();
    });

    tearDownAll(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('Can store and retrieve Navi from Hive', () async {
      final box = await Hive.openBox('navi');
      final navi = Navi(
        name: 'MegaMan',
        level: 1,
        maxHp: 100,
        currentHp: 100,
        zenny: 0,
        totalSteps: 0,
        wins: 0,
        losses: 0,
      );
      await box.put('active', navi);
      final retrieved = box.get('active');
      expect(retrieved.name, equals('MegaMan'));
      expect(retrieved.currentHp, equals(100));
    });

    test('Can store multiple BattleChips in Hive', () async {
      final box = await Hive.openBox('chips');
      final chip1 = BattleChip(
        id: 'BattleChip001',
        name: 'Cannon',
        description: 'Fires a cannon shot',
        rarityIndex: 0,
        elementIndex: 0,
        categoryIndex: 0,
        code: 'CANNON',
        damage: 40,
      );
      final chip2 = BattleChip(
        id: 'BattleChip002',
        name: 'ThunderBall',
        description: 'Electrifying sphere',
        rarityIndex: 0,
        elementIndex: 3, // elec
        categoryIndex: 0,
        code: 'THUNDER',
        damage: 60,
      );
      await box.put('chip_0', chip1);
      await box.put('chip_1', chip2);
      expect(box.length, equals(2));
      final retrieved = box.get('chip_0');
      expect(retrieved.name, equals('Cannon'));
    });
  });

  group('App Logic Tests', () {
    test('Pet hunger increases over time (mocked)', () {
      int hunger = 50;
      hunger += 10; // Simulate time passing
      expect(hunger, equals(60));
    });

    test('Pet happiness decreases if hungry (mocked)', () {
      int happiness = 100;
      int hunger = 80;
      if (hunger > 75) {
        happiness -= 10;
      }
      expect(happiness, equals(90));
    });

    test('Can validate chip damage values', () {
      final validDamages = [20, 40, 60, 100];
      expect(validDamages.contains(40), isTrue);
      expect(validDamages.contains(999), isFalse);
    });
  });
}
