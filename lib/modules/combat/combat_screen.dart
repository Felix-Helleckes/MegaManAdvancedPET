import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pet/l10n/app_localizations.dart';
import '../../shared/theme/pet_theme.dart';
import '../../core/models/battle_chip.dart';
import 'combat_provider.dart';
import '../singleplayer/singleplayer_provider.dart';

class CombatScreen extends StatefulWidget {
  final bool isVirus;
  const CombatScreen({super.key, required this.isVirus});

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  late AnimationController _flashCtrl;
  late Animation<double> _shake;
  late Animation<double> _flash;

  @override
  void initState() {
    super.initState();

    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _flashCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _shake = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeCtrl);
    _flash = Tween<double>(begin: 0, end: 1).animate(_flashCtrl);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<SingleplayerProvider>();
      context.read<CombatProvider>().startCombat(
            playerNavi: sp.navi,
            playerChips: sp.chips,
            isVirus: widget.isVirus,
          );
    });
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _flashCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PetTheme.background,
      body: SafeArea(
        child: Consumer2<CombatProvider, SingleplayerProvider>(
          builder: (ctx, combat, sp, _) {
            // Trigger animations on phase change
            if (combat.phase == CombatPhase.animating) {
              _shakeCtrl.forward(from: 0);
              _flashCtrl.forward(from: 0).then((_) => _flashCtrl.reverse());
            }
            _handleEndState(ctx, combat, sp);
            return _buildCombat(ctx, combat, sp);
          },
        ),
      ),
    );
  }

  void _handleEndState(BuildContext ctx, CombatProvider combat,
      SingleplayerProvider sp) {
    if (combat.phase == CombatPhase.victory ||
        combat.phase == CombatPhase.defeat) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (combat.phase == CombatPhase.victory) {
          await sp.claimVictoryReward(zennyReward: combat.zennyReward);
        } else {
          await sp.recordLoss();
        }
        if (!ctx.mounted) return;
        _showResultDialog(ctx, combat);
      });
    }
  }

  Widget _buildCombat(
      BuildContext ctx, CombatProvider c, SingleplayerProvider sp) {
    if (c.player == null || c.enemy == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final loc = AppLocalizations.of(ctx)!;
    return Column(
      children: [
        _topBar(ctx, loc),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _battleField(c),
              const SizedBox(height: 12),
              _logBox(c),
              const SizedBox(height: 12),
              if (c.phase == CombatPhase.selectChip) _chipRow(c, sp, loc),
              if (c.phase == CombatPhase.slashReady) _slashButton(c, loc),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar(BuildContext ctx, AppLocalizations loc) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: PetTheme.surface,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            color: PetTheme.textSecondary,
            onPressed: () {
              context.read<CombatProvider>().reset();
              Navigator.pop(ctx);
            },
          ),
          Expanded(
            child: Center(
              child: Text(widget.isVirus ? loc.combatVirusEncounter : loc.combatPvP,
                  style: GoogleFonts.pressStart2p(
                      fontSize: 10, color: PetTheme.danger,
                      letterSpacing: 2)),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _battleField(CombatProvider c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _unitCard(c.player!, PetTheme.primary, '⚡', isPlayer: true)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('VS',
                style: GoogleFonts.pressStart2p(
                    fontSize: 10, color: PetTheme.textSecondary)),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _shake,
              builder: (_, child) => Transform.translate(
                offset: Offset(_shake.value * (c.phase == CombatPhase.animating ? 1 : 0), 0),
                child: child,
              ),
              child: _unitCard(c.enemy!, PetTheme.danger, '👾', isPlayer: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitCard(unit, Color color, String emoji, {required bool isPlayer}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PetTheme.surface,
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            unit.name.length > 9 ? unit.name.substring(0, 9) : unit.name,
            style: GoogleFonts.pressStart2p(fontSize: 7, color: color),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: unit.hpFrac,
              minHeight: 8,
              backgroundColor: PetTheme.background,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 4),
          Text('${unit.hp}/${unit.maxHp}',
              style: GoogleFonts.pressStart2p(
                  fontSize: 6, color: PetTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _logBox(CombatProvider c) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      height: 72,
      decoration: BoxDecoration(
        color: PetTheme.surface,
        border: Border.all(color: PetTheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(c.log,
          style: GoogleFonts.pressStart2p(
              fontSize: 8, color: PetTheme.textPrimary, height: 1.6)),
    );
  }

  Widget _chipRow(CombatProvider c, SingleplayerProvider sp, AppLocalizations loc) {
    final chips = sp.chips;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(loc.combatSelectChip,
              style: GoogleFonts.pressStart2p(
                  fontSize: 8, color: PetTheme.textSecondary)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: chips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _chipTile(chips[i], c),
          ),
        ),
      ],
    );
  }

  Widget _chipTile(BattleChip chip, CombatProvider c) {
    return GestureDetector(
      onTap: () => c.selectChip(chip),
      child: Container(
        width: 72,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: PetTheme.surface,
          border: Border.all(color: chip.rarityColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(chip.elementEmoji,
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(chip.name,
                style: GoogleFonts.pressStart2p(
                    fontSize: 6, color: chip.rarityColor),
                maxLines: 2,
                textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(chip.damage > 0 ? '${chip.damage}' : 'HEAL',
                style: GoogleFonts.pressStart2p(
                    fontSize: 8, color: PetTheme.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _slashButton(CombatProvider c, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(loc.combatShake,
              style: GoogleFonts.pressStart2p(
                  fontSize: 8, color: PetTheme.textSecondary)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PetTheme.danger,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: GoogleFonts.pressStart2p(fontSize: 12),
              ),
              onPressed: c.executeAttack,
              child: Text(loc.combatSlash,
                  style: GoogleFonts.pressStart2p(
                      fontSize: 12, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showResultDialog(BuildContext ctx, CombatProvider combat) {
    final won = combat.phase == CombatPhase.victory;
    final loc = AppLocalizations.of(ctx)!;
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: PetTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: won ? PetTheme.primary : PetTheme.danger,
            width: 2,
          ),
        ),
        title: Text(
          won ? '★ ${loc.combatVictory} ★' : 'X ${loc.combatDefeat} X',
          style: GoogleFonts.pressStart2p(
              fontSize: 12,
              color: won ? PetTheme.primary : PetTheme.danger),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (won)
              Text('+${combat.zennyReward} ${loc.homeZenny}',
                  style: GoogleFonts.pressStart2p(
                      fontSize: 10, color: PetTheme.warning),
                  textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                combat.reset();
                Navigator.pop(ctx);
                Navigator.pop(ctx);
              },
              child: Text(won ? loc.combatAwesome : loc.combatRetreat),
            ),
          ),
        ],
      ),
    );
  }
}
