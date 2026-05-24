import 'package:hive/hive.dart';
import 'models/navi.dart';
import 'models/battle_chip.dart';

class Storage {
  static Box<Navi> naviBox() => Hive.box<Navi>('navi');
  static Box<BattleChip> chipsBox() => Hive.box<BattleChip>('chips');
  static Box settingsBox() => Hive.box('settings');

  static Navi? getActiveNavi() {
    final box = naviBox();
    if (box.isEmpty) return null;
    return box.getAt(0);
  }

  static Future<void> saveNavi(Navi navi) async {
    final box = naviBox();
    if (box.isEmpty) {
      await box.add(navi);
    } else {
      final existing = box.getAt(0) as Navi;
      existing.name = navi.name;
      existing.level = navi.level;
      existing.currentHp = navi.currentHp;
      existing.maxHp = navi.maxHp;
      existing.zenny = navi.zenny;
      await existing.save();
    }
  }
}
