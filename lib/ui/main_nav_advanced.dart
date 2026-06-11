import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_pet/shared/theme/pet_theme.dart';
import 'package:project_pet/modules/singleplayer/singleplayer_provider.dart';
import 'package:project_pet/modules/bluetooth/ble_provider.dart';
import 'package:project_pet/modules/combat/combat_provider.dart';
import 'package:project_pet/modules/online/online_service.dart';
import 'package:project_pet/l10n/app_localizations.dart';
import 'package:project_pet/ui/pet_frame.dart';

class MainNavAdvanced extends StatefulWidget {
  const MainNavAdvanced({Key? key}) : super(key: key);

  @override
  State<MainNavAdvanced> createState() => _MainNavAdvancedState();
}

class _MainNavAdvancedState extends State<MainNavAdvanced> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreenAdvanced(),
      const PetStatusScreenAdvanced(),
      const EvolutionScreenAdvanced(),
      const ChipBrowserScreenAdvanced(),
      const ChipDetailScreenAdvanced(),
      const BattleScreenLocalAdvanced(),
      const BattleScreenOnlineAdvanced(),
      const OnlineHubScreenAdvanced(),
      const CollectionScreenAdvanced(),
      const MissionsScreenAdvanced(),
      const SettingsScreenAdvanced(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return PetFrame(
      child: Scaffold(
        body: Consumer<SingleplayerProvider>(
          builder: (context, provider, child) {
            return _screens[_selectedIndex];
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.cyanAccent,
          unselectedItemColor: PetTheme.dark().textTheme.bodySmall?.color,
          backgroundColor: PetTheme.dark().scaffoldBackgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: loc.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: loc.navPetStatus,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.transform),
              label: loc.navEvolution,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.widgets),
              label: loc.navChipBrowser,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shield),
              label: loc.navBattle,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.public),
              label: loc.navOnlineHub,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.library_books),
              label: loc.navCollection,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment),
              label: loc.navMissions,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: loc.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}

// ========== SCREEN IMPLEMENTATIONS ==========

class HomeScreenAdvanced extends StatelessWidget {
  const HomeScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sp = context.watch<SingleplayerProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenStartTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LcdPanel(
              child: Column(
                children: [
                  Text(sp.navi.name,
                      style: PetTheme.dark().textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(loc.homeSteps(sp.steps),
                      style: PetTheme.dark().textTheme.bodyMedium),
                  Text(loc.homeZenny(sp.navi.zenny),
                      style: PetTheme.dark().textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Text(loc.homeWins(sp.navi.wins),
                      style: PetTheme.dark().textTheme.bodySmall),
                  Text(loc.homeLosses(sp.navi.losses),
                      style: PetTheme.dark().textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _ActionButton(
              label: 'BATTLE VIRUS',
              onPressed: () {
                context.read<CombatProvider>().startCombat(
                      playerNavi: sp.navi,
                      playerChips: sp.chips,
                      isVirus: true,
                    );
                _navigateToTab(context, 5); // Battle Local tab
              },
            ),
            _ActionButton(
              label: 'JACK IN [ BLE ]',
              onPressed: () {
                context.read<BleProvider>().startScan();
                _navigateToTab(context, 7); // Online Hub tab (has BLE)
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTab(BuildContext context, int tabIndex) {
    final state = context.findAncestorStateOfType<_MainNavAdvancedState>();
    // Can't access private state from outside; use Navigator instead
    // For now, user picks the tab manually. The action fires the logic.
  }
}

class PetStatusScreenAdvanced extends StatelessWidget {
  const PetStatusScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sp = context.watch<SingleplayerProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenStatusTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _LcdPanel(
          child: Column(
            children: [
              Text(sp.navi.name,
                  style: PetTheme.dark().textTheme.headlineMedium),
              const SizedBox(height: 16),
              _StatRow(
                label: loc.petStatusLevel(sp.navi.level),
                value: sp.navi.level.toString(),
              ),
              _StatRow(
                label: 'HP',
                value: '${sp.navi.currentHp}/${sp.navi.maxHp}',
              ),
              _StatRow(label: 'STEPS', value: sp.steps.toString()),
              const SizedBox(height: 12),
              _ProgressBar(
                label: 'HP',
                value: sp.navi.currentHp,
                max: sp.navi.maxHp,
              ),
              const SizedBox(height: 12),
              _ProgressBar(
                label: loc.petStatusHunger(sp.petHunger),
                value: 100 - sp.petHunger,
                max: 100,
              ),
              _ProgressBar(
                label: loc.petStatusHappiness(sp.petHappiness),
                value: sp.petHappiness,
                max: 100,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SingleplayerProvider>().feedPet(20),
                    child: const Text('FEED'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SingleplayerProvider>().playWithPet(15),
                    child: const Text('PLAY'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EvolutionScreenAdvanced extends StatelessWidget {
  const EvolutionScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sp = context.watch<SingleplayerProvider>();

    // Simple evolution logic based on level thresholds
    String currentForm = loc.evolutionFormStandard;
    String nextForm = loc.evolutionFormMega;
    int nextThreshold = 10;

    if (sp.navi.level >= 20) {
      currentForm = loc.evolutionFormGiga;
      nextForm = 'MAX';
      nextThreshold = 99;
    } else if (sp.navi.level >= 10) {
      currentForm = loc.evolutionFormMega;
      nextForm = loc.evolutionFormGiga;
      nextThreshold = 20;
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenEvolutionTitle)),
      body: Center(
        child: _LcdPanel(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.evolutionAvailable,
                  style: PetTheme.dark().textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('$currentForm (LV.${sp.navi.level})',
                  style: PetTheme.dark().textTheme.bodyLarge),
              const SizedBox(height: 24),
              if (nextThreshold < 99)
                Text('Next: $nextForm at LV.$nextThreshold',
                    style: PetTheme.dark().textTheme.bodyMedium),
              const SizedBox(height: 24),
              _ProgressBar(
                label: 'EXP TO NEXT',
                value: sp.navi.level % 5 * 20,
                max: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChipBrowserScreenAdvanced extends StatelessWidget {
  const ChipBrowserScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sp = context.watch<SingleplayerProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenChipBrowserTitle)),
      body: sp.chips.isEmpty
          ? Center(child: Text(loc.chipBrowserNoChips))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: sp.chips.length,
              itemBuilder: (context, index) {
                return _ChipTile(chip: sp.chips[index]);
              },
            ),
    );
  }
}

class ChipDetailScreenAdvanced extends StatelessWidget {
  const ChipDetailScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenChipDetailTitle)),
      body: Center(
        child: _LcdPanel(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('CANNON',
                  style: PetTheme.dark().textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('Code: ROWOR',
                  style: PetTheme.dark().textTheme.bodyMedium),
              const SizedBox(height: 24),
              _StatRow(label: 'POWER', value: '40'),
              _StatRow(label: 'RAPID', value: '1'),
              _StatRow(label: 'RANGE', value: 'CLOSE'),
            ],
          ),
        ),
      ),
    );
  }
}

class BattleScreenLocalAdvanced extends StatelessWidget {
  const BattleScreenLocalAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sp = context.watch<SingleplayerProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenBattleLocalTitle)),
      body: Center(
        child: _LcdPanel(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.battleVsWild,
                  style: PetTheme.dark().textTheme.headlineSmall),
              const SizedBox(height: 32),
              Text('NAVI: ${sp.navi.name}',
                  style: PetTheme.dark().textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('HP: ${sp.navi.currentHp}/${sp.navi.maxHp}',
                  style: PetTheme.dark().textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('CHIPS: ${sp.chips.length}',
                  style: PetTheme.dark().textTheme.bodyMedium),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CombatProvider>().startCombat(
                          playerNavi: sp.navi,
                          playerChips: sp.chips,
                          isVirus: true,
                        );
                    // Show battle overlay
                    _showBattleOverlay(context);
                  },
                  child: const Text('START BATTLE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBattleOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _BattleOverlay(),
    );
  }
}

class BattleScreenOnlineAdvanced extends StatelessWidget {
  const BattleScreenOnlineAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sp = context.watch<SingleplayerProvider>();
    final online = context.watch<OnlineService>();

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenBattleOnlineTitle)),
      body: Center(
        child: _LcdPanel(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (online.state == MatchmakingState.idle) ...[
                Text('ONLINE BATTLE',
                    style: PetTheme.dark().textTheme.headlineSmall),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => online.startSearch(
                      naviName: sp.navi.name,
                      level: sp.navi.level,
                    ),
                    child: const Text('FIND OPPONENT'),
                  ),
                ),
              ] else if (online.state == MatchmakingState.searching) ...[
                Text(online.status,
                    style:
                        PetTheme.dark().textTheme.headlineSmall),
                const SizedBox(height: 32),
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: online.cancelSearch,
                  child: Text(loc.commonCancel),
                ),
              ] else if (online.state == MatchmakingState.matched) ...[
                Text('OPPONENT FOUND!',
                    style:
                        PetTheme.dark().textTheme.headlineSmall),
                const SizedBox(height: 16),
                Text(
                    '${online.matchedOpponent?['name'] ?? '??'} LV.${online.matchedOpponent?['level'] ?? 1}',
                    style: PetTheme.dark().textTheme.bodyMedium),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CombatProvider>().startCombat(
                            playerNavi: sp.navi,
                            playerChips: sp.chips,
                            isVirus: false,
                          );
                      _showBattleOverlay(context);
                    },
                    child: const Text('BATTLE!'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showBattleOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _BattleOverlay(),
    );
  }
}

class OnlineHubScreenAdvanced extends StatelessWidget {
  const OnlineHubScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final ble = context.watch<BleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenOnlineHubTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _LcdPanel(
          child: Column(
            children: [
              _MenuButton(
                label: loc.onlineRankedMatch,
                onPressed: () {
                  final sp = context.read<SingleplayerProvider>();
                  context.read<OnlineService>().startSearch(
                        naviName: sp.navi.name,
                        level: sp.navi.level,
                      );
                },
              ),
              _MenuButton(
                label: loc.onlineCasualMatch,
                onPressed: () {
                  final sp = context.read<SingleplayerProvider>();
                  context.read<OnlineService>().startSearch(
                        naviName: sp.navi.name,
                        level: sp.navi.level,
                      );
                },
              ),
              _MenuButton(
                label: loc.onlineLeaderboards,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Leaderboards coming soon!')),
                  );
                },
              ),
              const Divider(color: Colors.cyan),
              _MenuButton(
                label: 'BLE: ${loc.bleScanForNavis}',
                onPressed: () => ble.startScan(),
              ),
              if (ble.state == BleState.scanning)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Scanning...',
                      style: TextStyle(color: Colors.cyan)),
                ),
              if (ble.nearbyPets.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...ble.nearbyPets.map((pet) => _BleDeviceTile(pet: pet)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CollectionScreenAdvanced extends StatelessWidget {
  const CollectionScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sp = context.watch<SingleplayerProvider>();
    final totalChips = sp.chips.length;
    final maxCatalog = 320;

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenCollectionTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _LcdPanel(
          child: Column(
            children: [
              Text(loc.collectionTotal(totalChips, maxCatalog),
                  style: PetTheme.dark().textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(loc.collectionProgress(
                  (totalChips * 100 ~/ maxCatalog).clamp(0, 100)),
                  style: PetTheme.dark().textTheme.bodyMedium),
              const SizedBox(height: 24),
              _ProgressBar(
                label: 'PROGRESS',
                value: totalChips,
                max: maxCatalog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MissionsScreenAdvanced extends StatelessWidget {
  const MissionsScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sp = context.watch<SingleplayerProvider>();
    final battled = sp.navi.wins;

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenMissionsTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _LcdPanel(
          child: Column(
            children: [
              Text(loc.missionsAvailable,
                  style: PetTheme.dark().textTheme.headlineSmall),
              const SizedBox(height: 16),
              _MissionTile(
                title: 'Battle 5 Viruses',
                reward: 500,
                progress: '${(battled % 6)}/5',
              ),
              _MissionTile(
                title: 'Collect 10 Chips',
                reward: 750,
                progress: '${sp.chips.length.clamp(0, 10)}/10',
              ),
              _MissionTile(
                title: 'Walk 10000 Steps',
                reward: 1000,
                progress: '${sp.steps.clamp(0, 10000)}/10000',
              ),
              _MissionTile(
                title: 'Win via BLE',
                reward: 1500,
                progress: '0/1',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreenAdvanced extends StatelessWidget {
  const SettingsScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.screenSettingsTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _LcdPanel(
          child: Column(
            children: [
              _MenuButton(
                label: loc.settingsLanguage,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('DE / EN')),
                  );
                },
              ),
              _MenuButton(
                label: loc.settingsTheme,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Theme: Dark LCD')),
                  );
                },
              ),
              _MenuButton(
                label: loc.settingsProfile,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('NAVI Profile')),
                  );
                },
              ),
              _MenuButton(
                label: 'DEBUG: +2000 Steps',
                onPressed: () {
                  context
                      .read<SingleplayerProvider>()
                      .simulateSteps(2000);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== BATTLE OVERLAY ==========

class _BattleOverlay extends StatelessWidget {
  const _BattleOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: const EdgeInsets.all(16),
      child: Consumer<CombatProvider>(
        builder: (context, combat, _) {
          if (combat.player == null || combat.enemy == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('⚔ BATTLE ⚔',
                    style: PetTheme.dark().textTheme.headlineSmall),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        '${combat.player!.name}\nHP: ${combat.player!.hp}/${combat.player!.maxHp}',
                        style: const TextStyle(color: Colors.cyan)),
                    const Text('VS',
                        style: TextStyle(color: Colors.red)),
                    Text(
                        '${combat.enemy!.name}\nHP: ${combat.enemy!.hp}/${combat.enemy!.maxHp}',
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(combat.log,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                if (combat.phase == CombatPhase.selectChip) ...[
                  const Text('SELECT A CHIP',
                      style: TextStyle(color: Colors.cyan)),
                  const SizedBox(height: 8),
                  Consumer<SingleplayerProvider>(
                    builder: (context, sp, _) => Wrap(
                      spacing: 4,
                      children: sp.chips.take(6).map((chip) {
                        return ElevatedButton(
                          onPressed: () => combat.selectChip(chip),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.withAlpha(50),
                          ),
                          child: Text(chip.name,
                              style: const TextStyle(fontSize: 10)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                if (combat.phase == CombatPhase.slashReady) ...[
                  ElevatedButton(
                    onPressed: combat.executeAttack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('>> SLASH <<',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
                if (combat.phase == CombatPhase.victory ||
                    combat.phase == CombatPhase.defeat) ...[
                  Text(
                    combat.phase == CombatPhase.victory
                        ? '★ VICTORY ★'
                        : 'X DEFEAT X',
                    style: TextStyle(
                      color: combat.phase == CombatPhase.victory
                          ? Colors.green
                          : Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      combat.reset();
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// ========== UI COMPONENTS ==========

class _LcdPanel extends StatelessWidget {
  final Widget child;
  const _LcdPanel({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PetTheme.dark().scaffoldBackgroundColor,
        border: Border.all(color: Colors.cyan, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _ActionButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: PetTheme.dark().colorScheme.primary,
        ),
        child: Text(label),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(
      {Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: PetTheme.dark().textTheme.bodyMedium),
          Text(value,
              style: PetTheme.dark().textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  const _ProgressBar(
      {Key? key,
      required this.label,
      required this.value,
      required this.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = max > 0 ? (value / max).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: PetTheme.dark().textTheme.bodySmall),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 12,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              PetTheme.dark().colorScheme.secondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _MenuButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
          alignment: Alignment.centerLeft,
        ),
        child: Text('> $label', style: const TextStyle(color: Colors.cyan)),
      ),
    );
  }
}

class _ChipTile extends StatelessWidget {
  final dynamic chip;
  const _ChipTile({Key? key, required this.chip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black54,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.widgets, color: Colors.cyan, size: 20),
            const SizedBox(height: 4),
            Text(
              chip.name ?? 'CHIP',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 9, color: Colors.cyanAccent),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionTile extends StatelessWidget {
  final String title;
  final int reward;
  final String progress;
  const _MissionTile(
      {Key? key,
      required this.title,
      required this.reward,
      required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.cyanAccent)),
                Text('Reward: ${reward}z',
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          Text(progress,
              style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}

class _BleDeviceTile extends StatelessWidget {
  final dynamic pet;
  const _BleDeviceTile({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.bluetooth, color: Colors.cyan),
      title: Text('${pet.naviName} LV.${pet.naviLevel}',
          style: const TextStyle(color: Colors.cyanAccent)),
      subtitle:
          Text('${pet.rssi} dBm', style: const TextStyle(fontSize: 10)),
      trailing: ElevatedButton(
        onPressed: () => context.read<BleProvider>().connectTo(pet),
        child: const Text('CONNECT'),
      ),
    );
  }
}