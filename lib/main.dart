import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Directory, File, Platform;
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
import 'ui/pet_bottom_widget.dart';

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

  // Ensure any downloaded BattleChip images (assets/images/chips/BattleChip###.png)
  // have a placeholder entry in the chips box so they appear in the app.
  try {
    final assetDir = Directory('assets/images/chips');
    if (await assetDir.exists()) {
      final files = assetDir.listSync().whereType<File>();
      for (final f in files) {
        final m = RegExp(r'BattleChip(\d{3})\.png').firstMatch(f.path.split(Platform.pathSeparator).last);
        if (m != null) {
          final id = 'chip_${int.parse(m.group(1)!).toString()}';
          final exists = chipsBox.values.any((c) => c.id == id);
          if (!exists) {
            // add a placeholder BattleChip so the image is represented in-app
            await chipsBox.add(BattleChip(
              id: id,
              name: 'Chip ${m.group(1)}',
              damage: 0,
              description: 'Imported from wiki assets',
              rarityIndex: 0,
              elementIndex: 0,
              categoryIndex: 0,
              code: '?',
            ));
          }
        }
      }
    }
  } catch (_) {
    // best-effort only; don't block startup on asset scanning
  }

  // Init background step service (guard against plugin errors so emulator doesn't crash)
  try {
    await StepService.initialize();
  } catch (e, st) {
    // If StepService fails, log and continue; StepService will fallback to simulation where possible
    debugPrint('[Main] StepService.initialize failed: $e');
    debugPrint('$st');
  }

  bool hasNavi = Hive.box<Navi>('navi').isNotEmpty;

  // Toggle this to `true` to preview the PET bottom UI locally without
  // running the full app navigation. This is intentionally a local-only
  // debug switch for quick visual testing. Set to `false` for normal app.
  const bool previewPetBottom = false;

  if (previewPetBottom) {
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(child: PetBottomWidget()),
        ),
      ),
    ));
  } else {
    runApp(ProjectPetApp(hasNavi: hasNavi));
  }
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

