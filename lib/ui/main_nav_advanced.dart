import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_pet/shared/theme/pet_theme.dart';
import 'package:project_pet/modules/singleplayer/singleplayer_provider.dart';
import 'package:project_pet/l10n/app_localizations.dart';

class MainNavAdvanced extends StatefulWidget {
  const MainNavAdvanced({Key? key}) : super(key: key);

  @override
  State<MainNavAdvanced> createState() => _MainNavAdvancedState();
}

class _MainNavAdvancedState extends State<MainNavAdvanced> {
  int _selectedIndex = 0;

  /// All 11 screens matching UXBook design
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreenAdvanced(),           // 00 HOME
      const PetStatusScreenAdvanced(),      // 01 PET STATUS  
      const EvolutionScreenAdvanced(),      // 02 EVOLUTION
      const ChipBrowserScreenAdvanced(),    // 03 CHIP BROWSER
      const ChipDetailScreenAdvanced(),     // 04 CHIP DETAIL
      const BattleScreenLocalAdvanced(),    // 05 BATTLE LOCAL
      const BattleScreenOnlineAdvanced(),   // 06 BATTLE ONLINE
      const OnlineHubScreenAdvanced(),      // 07 ONLINE HUB
      const CollectionScreenAdvanced(),     // 08 COLLECTION
      const MissionsScreenAdvanced(),       // 09 MISSIONS
      const SettingsScreenAdvanced(),       // 10 SETTINGS
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Scaffold(
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
            icon: const Icon(Icons.info),
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
    );
  }
}

// ========== SCREEN IMPLEMENTATIONS ==========

class HomeScreenAdvanced extends StatelessWidget {
  const HomeScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenStartTitle)),
      body: Consumer<SingleplayerProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LcdPanel(
                    child: Column(
                      children: [
                        Text(provider.navi.name,
                            style: PetTheme.dark().textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text(loc.homeSteps(provider.steps),
                            style: PetTheme.dark().textTheme.bodyMedium),
                        Text(loc.homeZenny(provider.navi.zenny),
                            style: PetTheme.dark().textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        Text(loc.homeWins(provider.navi.wins),
                            style: PetTheme.dark().textTheme.bodySmall),
                        Text(loc.homeLosses(provider.navi.losses),
                            style: PetTheme.dark().textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ActionButton(
                    label: 'BATTLE VIRUS',
                    onPressed: () {
                      // TODO: Start battle
                    },
                  ),
                  _ActionButton(
                    label: 'JACK IN [ BLE ]',
                    onPressed: () {
                      // TODO: Start BLE match
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PetStatusScreenAdvanced extends StatelessWidget {
  const PetStatusScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenStatusTitle)),
      body: Consumer<SingleplayerProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _LcdPanel(
                child: Column(
                  children: [
                    Text(provider.navi.name,
                        style: PetTheme.dark().textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    _StatRow(
                      label: loc.petStatusLevel(provider.navi.level),
                      value: provider.navi.level.toString(),
                    ),
                    _StatRow(
                      label: 'HP',
                      value:
                          '${provider.navi.currentHp}/${provider.navi.maxHp}',
                    ),
                    _ProgressBar(
                      label: 'HP',
                      value: provider.navi.currentHp,
                      max: provider.navi.maxHp,
                    ),
                    const SizedBox(height: 12),
                    _ProgressBar(
                      label: loc.petStatusHunger(50),
                      value: 50,
                      max: 100,
                    ),
                    _ProgressBar(
                      label: loc.petStatusHappiness(75),
                      value: 75,
                      max: 100,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EvolutionScreenAdvanced extends StatelessWidget {
  const EvolutionScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenEvolutionTitle)),
      body: Center(
        child: _LcdPanel(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.evolutionFormStandard,
                  style: PetTheme.dark().textTheme.headlineSmall),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: Text(loc.evolutionFormMega),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                child: Text(loc.evolutionFormGiga),
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
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenChipBrowserTitle)),
      body: Consumer<SingleplayerProvider>(
        builder: (context, provider, _) {
          final chips = provider.chips;
          return _LcdPanel(
            child: chips.isEmpty
                ? Center(
                    child: Text(loc.chipBrowserNoChips),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: chips.length,
                    itemBuilder: (context, index) {
                      return _ChipTile(chip: chips[index]);
                    },
                  ),
          );
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
              Text('CANNON', style: PetTheme.dark().textTheme.headlineSmall),
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
              _ProgressBar(label: 'YOUR HP', value: 100, max: 100),
              const SizedBox(height: 16),
              _ProgressBar(label: 'ENEMY HP', value: 50, max: 80),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('CHIP')),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('ATTACK')),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('DEFEND')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BattleScreenOnlineAdvanced extends StatelessWidget {
  const BattleScreenOnlineAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenBattleOnlineTitle)),
      body: Center(
        child: _LcdPanel(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SEARCHING FOR OPPONENT...',
                  style: PetTheme.dark().textTheme.bodyMedium),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: Text(loc.commonCancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnlineHubScreenAdvanced extends StatelessWidget {
  const OnlineHubScreenAdvanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenOnlineHubTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _LcdPanel(
            child: Column(
              children: [
                _MenuButton(
                  label: loc.onlineRankedMatch,
                  onPressed: () {},
                ),
                _MenuButton(
                  label: loc.onlineCasualMatch,
                  onPressed: () {},
                ),
                _MenuButton(
                  label: loc.onlineLeaderboards,
                  onPressed: () {},
                ),
              ],
            ),
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
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenCollectionTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _LcdPanel(
          child: Column(
            children: [
              Text(loc.collectionTotal(45, 100),
                  style: PetTheme.dark().textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(loc.collectionProgress(45),
                  style: PetTheme.dark().textTheme.bodyMedium),
              const SizedBox(height: 24),
              _ProgressBar(label: 'PROGRESS', value: 45, max: 100),
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
    return Scaffold(
      appBar: AppBar(title: Text(loc.screenMissionsTitle)),
      body: SingleChildScrollView(
        child: Padding(
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
                  progress: '3/5',
                ),
                _MissionTile(
                  title: 'Collect 10 Chips',
                  reward: 750,
                  progress: '7/10',
                ),
              ],
            ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _LcdPanel(
            child: Column(
              children: [
                _MenuButton(
                  label: loc.settingsLanguage,
                  onPressed: () {},
                ),
                _MenuButton(
                  label: loc.settingsTheme,
                  onPressed: () {},
                ),
                _MenuButton(
                  label: loc.settingsProfile,
                  onPressed: () {},
                ),
                _MenuButton(
                  label: loc.commonBack,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
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
  const _StatRow({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: PetTheme.dark().textTheme.bodyMedium),
        Text(value, style: PetTheme.dark().textTheme.bodyMedium),
      ],
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
    final percent = (value / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: PetTheme.dark().textTheme.bodySmall),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
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
  const _MenuButton({Key? key, required this.label, required this.onPressed})
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
        child: Text('> $label'),
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
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.widgets, color: Colors.cyan),
            const SizedBox(height: 4),
            Text(
              chip.name ?? 'CHIP',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
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
                Text(title),
                Text('Reward: ${reward}z', style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          Text(progress),
        ],
      ),
    );
  }
}
