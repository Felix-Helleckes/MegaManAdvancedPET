import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io' show File;
import 'package:flutter/services.dart';
import 'package:project_pet/l10n/app_localizations.dart';
import '../../shared/theme/pet_theme.dart';
import '../../core/app_router.dart';
import 'singleplayer_provider.dart';
import '../../widgets/advanced_pet_housing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _slotFlash = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PetTheme.background,
      body: SafeArea(
            child: Consumer<SingleplayerProvider>(
          builder: (context, sp, _) {
            if (sp.encounterPending) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showEncounterDialog(context, sp);
              });
            }
            final loc = AppLocalizations.of(context)!;
            final navi = sp.navi;
            final hpFrac = (navi.maxHp > 0) ? (navi.currentHp / navi.maxHp) : 0.0;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTopBar(loc),
                  _naviDisplay(navi, hpFrac, sp),
                  const SizedBox(height: 20),
                  _stepMeter(sp),
                  const SizedBox(height: 20),
                  _statsRow(navi),
                  const SizedBox(height: 20),
                  _actionButtons(context),
                  const SizedBox(height: 20),
                  _debugPanel(sp),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _buildTopBar(AppLocalizations loc) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: PetTheme.surface,
        border: Border(bottom: BorderSide(color: PetTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(loc.appTitle.toUpperCase(),
              style: GoogleFonts.pressStart2p(
                  fontSize: 10, color: PetTheme.primary,
                  letterSpacing: 2)),
          ScaleTransition(
            scale: _pulse,
            child: Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(
                color: PetTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _naviDisplay(navi, double hpFrac, SingleplayerProvider sp) {
    // Device-like PET frame (red) with screen in the center showing the Navi
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // PET housing frame behind the internal UI
          const Positioned.fill(
            child: Center(
              child: AdvancedPetHousing(width: 380, height: 520),
            ),
          ),

          Container(
        width: 320,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        // Make the inner UI transparent so the AdvancedPetHousing frame shows through
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top speaker / status bar
            Container(
              height: 10,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            // Chip slot (top)
                       DragTarget<int>(
              onWillAcceptWithDetails: (data) => true,
              onAcceptWithDetails: (data) {
                HapticFeedback.mediumImpact();
                setState(() => _slotFlash = true);
                Timer(const Duration(milliseconds: 220), () => setState(() => _slotFlash = false));
                // show brief confirmation
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Slot-In!')));
              },
              builder: (context, c, r) => Container(
                width: 160,
                height: 26,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: _slotFlash ? PetTheme.primary : Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: PetTheme.border),
                ),
                child: Center(
                  child: Text('CHIP SLOT', style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textSecondary)),
                ),
              ),
            ),
            // Screen with scanlines / grid
            Container(
              width: 260,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 8, offset: const Offset(0,4))],
                border: Border.all(color: const Color(0xFF2B2B2B), width: 4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  children: [
                    // retro grid / scanlines painter
                    Positioned.fill(child: CustomPaint(painter: _ScanlinePainter())),
                    // Center Navi avatar (modern colored placeholder)
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [PetTheme.accent.withOpacity(0.9), PetTheme.primary.withOpacity(0.95)]),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: PetTheme.accent.withOpacity(0.4), blurRadius: 20, spreadRadius: 1)],
                          border: Border.all(color: PetTheme.primary, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            navi.name.isNotEmpty ? navi.name[0].toUpperCase() : 'N',
                            style: GoogleFonts.pressStart2p(fontSize: 48, color: PetTheme.textPrimary),
                          ),
                        ),
                      ),
                    ),
                    // Top-left HUD: name + level
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(navi.name.toUpperCase(), style: GoogleFonts.pressStart2p(fontSize: 10, color: PetTheme.textPrimary)),
                          const SizedBox(height: 4),
                          Text('LV.${navi.level}', style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textSecondary)),
                        ],
                      ),
                    ),
                    // Bottom HUD: HP bar
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('HP', style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textSecondary)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: hpFrac.clamp(0.0, 1.0),
                              minHeight: 12,
                              backgroundColor: Colors.grey.shade900,
                              valueColor: AlwaysStoppedAnimation(
                                hpFrac > 0.5 ? PetTheme.primary : hpFrac > 0.25 ? PetTheme.warning : PetTheme.danger,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('${navi.currentHp}/${navi.maxHp}', style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tamagotchi panel: hunger / happiness and actions
            _petPanel(sp),
            const SizedBox(height: 14),
            // Controls: D-Pad (left) and A/B buttons (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // D-Pad
                GestureDetector(
                  onTap: () { HapticFeedback.selectionClick(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('D-Pad press'))); },
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: PetTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: PetTheme.border),
                    ),
                    child: const Center(child: Icon(Icons.keyboard_arrow_up, color: PetTheme.textSecondary, size: 28)),
                  ),
                ),
                const SizedBox(width: 18),
                // A/B Buttons
                Column(
                  children: [
                    GestureDetector(
                      onTap: () { HapticFeedback.vibrate(); Navigator.pushNamed(context, AppRouter.combat, arguments: {'isVirus': true}); },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PetTheme.primary,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0,4))],
                          border: Border.all(color: PetTheme.border),
                        ),
                        child: Center(child: Text('A', style: GoogleFonts.pressStart2p(fontSize: 18, color: PetTheme.textPrimary))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () { HapticFeedback.vibrate(); _openChipFolder(context); },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PetTheme.accent,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0,3))],
                          border: Border.all(color: PetTheme.border),
                        ),
                        child: Center(child: Text('B', style: GoogleFonts.pressStart2p(fontSize: 14, color: PetTheme.textPrimary))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
          ),
          // overlay frame from UXBook (transparent screen area)
          Positioned.fill(
            child: IgnorePointer(
              child: Builder(builder: (context) {
                // During development the overlay may be present on disk but
                // not bundled as an asset; check file existence to avoid
                // noisy assertion logs and fall back gracefully.
                try {
                  // Use dart:io File at development time to detect the file.
                  // ignore: avoid_web_libraries_in_flutter
                  final overlayFile = File('assets/ux/overlay.png');
                  if (overlayFile.existsSync()) {
                    return Image.file(overlayFile, fit: BoxFit.contain);
                  }
                } catch (_) {}
                return const SizedBox.shrink();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepMeter(SingleplayerProvider sp) {
    const trigger = 2000;
    final progress = (trigger - sp.stepsToNextEncounter) / trigger;
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PetTheme.surface,
        border: Border.all(color: PetTheme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(loc.homeCyberMeter,
                  style: GoogleFonts.pressStart2p(
                      fontSize: 8, color: PetTheme.textSecondary)),
              Text(loc.homeSteps(sp.steps),
                  style: GoogleFonts.pressStart2p(
                      fontSize: 7, color: PetTheme.accent)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 14,
              backgroundColor: PetTheme.background,
              valueColor:
                  const AlwaysStoppedAnimation(PetTheme.accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(loc.homeStepsToEncounter(sp.stepsToNextEncounter),
              style: GoogleFonts.pressStart2p(
                  fontSize: 7, color: PetTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _statsRow(navi) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        _statBox(loc.homeZenny, '${navi.zenny}', PetTheme.warning),
        const SizedBox(width: 10),
        _statBox(loc.homeWins, '${navi.wins}', PetTheme.primary),
        const SizedBox(width: 10),
        _statBox(loc.homeLosses, '${navi.losses}', PetTheme.danger),
      ],
    );
  }

  Widget _petPanel(SingleplayerProvider sp) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 280,
      decoration: BoxDecoration(
        color: PetTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PetTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pet', style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hunger', style: GoogleFonts.pressStart2p(fontSize: 7, color: PetTheme.textSecondary)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: (100 - sp.petHunger) / 100.0,
                        backgroundColor: Colors.grey.shade900,
                        valueColor: const AlwaysStoppedAnimation(PetTheme.warning),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Happiness', style: GoogleFonts.pressStart2p(fontSize: 7, color: PetTheme.textSecondary)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: sp.petHappiness / 100.0,
                        backgroundColor: Colors.grey.shade900,
                        valueColor: const AlwaysStoppedAnimation(PetTheme.accent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => sp.feedPet(20),
                    child: Text('Feed', style: GoogleFonts.pressStart2p(fontSize: 8)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => sp.playWithPet(15),
                    child: Text('Play', style: GoogleFonts.pressStart2p(fontSize: 8)),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: PetTheme.surface,
          border: Border.all(color: PetTheme.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(label,
                style: GoogleFonts.pressStart2p(
                    fontSize: 6, color: PetTheme.textSecondary)),
            const SizedBox(height: 6),
            Text(value,
                style: GoogleFonts.pressStart2p(
                    fontSize: 14, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context, AppRouter.combat,
              arguments: {'isVirus': true},
            ),
            child: Text(loc.homeBattleVirus),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: PetTheme.accent,
              side: const BorderSide(color: PetTheme.accent),
              textStyle: GoogleFonts.pressStart2p(fontSize: 10),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.bluetooth),
            child: Text(loc.homeJackIn),
          ),
        ),
      ],
    );
  }

  Widget _debugPanel(SingleplayerProvider sp) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: PetTheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.homeDebug,
              style: GoogleFonts.pressStart2p(
                  fontSize: 7, color: PetTheme.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              _debugBtn('+100 steps', () => sp.simulateSteps(100)),
              const SizedBox(width: 8),
              _debugBtn('+2000 steps', () => sp.simulateSteps(2000)),
            ],
          ),
        ],
      ),
    );
  }

  void _openChipFolder(BuildContext context) {
    final sp = Provider.of<SingleplayerProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: PetTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chip Folder', style: GoogleFonts.pressStart2p(fontSize: 12, color: PetTheme.textPrimary)),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) => LongPressDraggable(
                  data: i,
                  feedback: Opacity(
                    opacity: 0.9,
                    child: _chipWidget(sp.chips[i], small: false),
                  ),
                  child: _chipWidget(sp.chips[i], small: true),
                ),
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: sp.chips.length,
              ),
            ),
            const SizedBox(height: 12),
            Text('Drag a chip into the slot to Slot-In', style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textSecondary)),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _chipWidget(chip, {bool small = true}) {
    final size = small ? 64.0 : 96.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PetTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Builder(builder: (_) {
          final assetPath = _assetForChip(chip);
          if (assetPath != null) return Image.asset(assetPath, fit: BoxFit.contain);
          if (chip.imageUrl != null) {
            return chip.imageUrl!.startsWith('assets/')
                ? Image.asset(chip.imageUrl, fit: BoxFit.contain)
                : Image.network(chip.imageUrl, fit: BoxFit.contain);
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  String? _assetForChip(dynamic chip) {
    try {
      final id = chip.id as String;
      final m = RegExp(r'^chip_(\d+) $').firstMatch(id);
      if (m != null) {
        final padded = int.parse(m.group(1)!).toString().padLeft(3, '0');
        return 'assets/images/chips/BattleChip$padded.png';
      }
    } catch (_) {}
    return null;
  }


  Widget _debugBtn(String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: PetTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.pressStart2p(
                    fontSize: 7, color: PetTheme.textSecondary)),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: PetTheme.surface,
        border: Border(top: BorderSide(color: PetTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(context, Icons.videogame_asset, 'PET', AppRouter.pet),
          _navItem(context, Icons.home, loc.navHome, AppRouter.home),
          _navItem(context, Icons.style, loc.navChips, AppRouter.chipFolder),
          _navItem(context, Icons.bluetooth, loc.navBle, AppRouter.bluetooth),
        ],
      ),
    );
  }

  Widget _navItem(
      BuildContext context, IconData icon, String label, String route) {
    return InkWell(
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: PetTheme.textSecondary, size: 20),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.pressStart2p(
                  fontSize: 6, color: PetTheme.textSecondary)),
        ],
      ),
    );
  }

  void _showEncounterDialog(
      BuildContext context, SingleplayerProvider sp) {
    sp.clearEncounter();
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: PetTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: PetTheme.danger, width: 2),
        ),
        title: Text(loc.virusAlertTitle,
            style: GoogleFonts.pressStart2p(
                fontSize: 12, color: PetTheme.danger),
            textAlign: TextAlign.center),
        content: Text(loc.virusAlertMessage,
            style: GoogleFonts.pressStart2p(
                fontSize: 9, color: PetTheme.textPrimary),
            textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.virusAlertFlee,
                style: GoogleFonts.pressStart2p(
                    fontSize: 9, color: PetTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.combat,
                  arguments: {'isVirus': true});
            },
            child: Text(loc.virusAlertBattle),
          ),
        ],
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // base tint
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0F1720));
    // faint grid
    final grid = Paint()..color = const Color(0xFF4DB6AC).withOpacity(0.06);
    const gap = 8.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    // scanlines
    final scan = Paint()..color = Colors.black.withOpacity(0.12);
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scan);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
 
