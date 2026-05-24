import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory;
import 'package:provider/provider.dart';

import 'package:project_pet/l10n/app_localizations.dart';

import 'core/app_router.dart';
import 'core/models/navi.dart';
import 'core/models/battle_chip.dart';
import 'modules/singleplayer/step_service.dart';
import 'modules/singleplayer/singleplayer_provider.dart';
import 'modules/combat/combat_provider.dart';
// Bluetooth provider disabled at startup to avoid emulator/system issues
// import 'modules/bluetooth/ble_provider.dart';
import 'shared/theme/pet_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Init local storage in an app-specific directory to avoid OneDrive locks
  final Directory appSupportDir = await getApplicationSupportDirectory();
  Hive.init(appSupportDir.path);
  Hive.registerAdapter(NaviAdapter());
  Hive.registerAdapter(BattleChipAdapter());
  await Hive.openBox<Navi>('navi');
  await Hive.openBox<BattleChip>('chips');
  await Hive.openBox('settings');

  // Seed chips box with full catalog if empty
  final chipsBox = Hive.box<BattleChip>('chips');
  if (chipsBox.isEmpty) {
    for (final c in BattleChip.fullCatalog) {
      await chipsBox.add(c);
    }
  }

  // Init background step service
  await StepService.initialize();

  bool hasNavi = Hive.box<Navi>('navi').isNotEmpty;

  runApp(ProjectPetApp(hasNavi: hasNavi));
}

class ProjectPetApp extends StatelessWidget {
  final bool hasNavi;
  const ProjectPetApp({super.key, required this.hasNavi});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SingleplayerProvider()..init()),
        ChangeNotifierProvider(create: (_) => CombatProvider()),
        // BleProvider omitted to isolate startup crash and for emulator stability
      ],
      child: MaterialApp(
        title: 'Project PET',
        debugShowCheckedModeBanner: false,
        theme: PetTheme.dark(), // Always dark – LCD aesthetic
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: hasNavi ? AppRouter.home : AppRouter.onboarding,
      ),
    );
  }
}

