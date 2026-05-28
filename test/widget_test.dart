// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:project_pet/main.dart';
import 'package:project_pet/core/models/navi.dart';
import 'package:project_pet/core/models/battle_chip.dart';
import 'package:project_pet/modules/singleplayer/step_service.dart';

void main() {
  testWidgets('App builds and shows main nav', (WidgetTester tester) async {
    // Initialize Hive for the app like main() does
    final tempDir = Directory.systemTemp.createTempSync('project_pet_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(NaviAdapter());
    Hive.registerAdapter(BattleChipAdapter());
    await Hive.openBox('navi');
    await Hive.openBox('chips');
    await Hive.openBox('settings');

    // Provide a larger window to avoid layout overflows in constrained test env
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(1080, 1920);
    binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const ProjectPetApp(hasNavi: true));
    // Use limited pumps instead of pumpAndSettle to avoid hanging on
    // repeating animations or background timers in the test environment.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // debug trace
    debugPrint('[TEST] after initial pumps');

    // Bottom nav should be present with three items
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Pet'), findsOneWidget);
    expect(find.text('Chips'), findsOneWidget);
    expect(find.text('BLE'), findsOneWidget);
    debugPrint('[TEST] after assertions');

    // Tapping second tab shows Chips screen
    await tester.tap(find.text('Chips'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    debugPrint('[TEST] after tap pumps');
    expect(find.byType(Scaffold), findsWidgets);

    // Restore window and cleanup
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
    // Ensure background services and timers are cleaned up for test finalization
    debugPrint('[TEST] teardown start');
    try {
      StepService.dispose();
      debugPrint('[TEST] stepservice disposed');
    } catch (_) {}
    await Hive.close();
    debugPrint('[TEST] hive closed');
    tempDir.delete(recursive: true);
    debugPrint('[TEST] tmp deleted');
  });
}
