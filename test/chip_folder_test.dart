import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:project_pet/modules/singleplayer/chip_folder_screen.dart';
import 'package:project_pet/modules/singleplayer/singleplayer_provider.dart';
import 'package:project_pet/core/models/battle_chip.dart';
import 'package:project_pet/core/models/navi.dart';

void main() {
  testWidgets('ChipFolder displays chips from Hive', (WidgetTester tester) async {
    final tempDir = Directory.systemTemp.createTempSync('project_pet_test_chips');
    Hive.init(tempDir.path);
    Hive.registerAdapter(NaviAdapter());
    Hive.registerAdapter(BattleChipAdapter());
    await Hive.openBox<Navi>('navi');
    final chipBox = await Hive.openBox<BattleChip>('chips');
    await Hive.openBox('settings');

    // seed a test chip
    final testChip = BattleChip(
      id: 'chip_999',
      name: 'Test Chip',
      damage: 5,
      description: 'Unit test chip',
      rarityIndex: 0,
      elementIndex: 0,
      categoryIndex: 0,
      code: 'T',
    );
    await chipBox.clear();
    await chipBox.add(testChip);

    final provider = SingleplayerProvider();
    await provider.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => provider)],
        child: const MaterialApp(home: ChipFolderScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Chip'), findsOneWidget);

    await Hive.close();
    tempDir.delete(recursive: true);
  });
}
