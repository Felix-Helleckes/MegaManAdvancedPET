import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pet/l10n/app_localizations.dart';
import '../../shared/theme/pet_theme.dart';
import '../../core/models/battle_chip.dart';
import '../singleplayer/singleplayer_provider.dart';

class ChipFolderScreen extends StatefulWidget {
  const ChipFolderScreen({super.key});

  @override
  State<ChipFolderScreen> createState() => _ChipFolderScreenState();
}

class _ChipFolderScreenState extends State<ChipFolderScreen> {
  ChipRarity? _filterRarity;
  ChipElement? _filterElement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PetTheme.background,
      body: SafeArea(
        child: Consumer<SingleplayerProvider>(
          builder: (ctx, sp, _) {
            final chips = _filtered(sp.chips);
            final loc = AppLocalizations.of(ctx)!;
            return Column(
              children: [
                _topBar(ctx, sp.chips.length, loc),
                _filterBar(loc),
                Expanded(child: _chipGrid(ctx, chips, sp, loc)),
              ],
            );
          },
        ),
      ),
    );
  }

  List<BattleChip> _filtered(List<BattleChip> chips) {
    return chips.where((c) {
      if (_filterRarity != null && c.rarity != _filterRarity) return false;
      if (_filterElement != null && c.element != _filterElement) return false;
      return true;
    }).toList()
      ..sort((a, b) => a.rarityIndex.compareTo(b.rarityIndex));
  }

  Widget _topBar(BuildContext ctx, int total, AppLocalizations loc) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: PetTheme.surface,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            color: PetTheme.textSecondary,
            onPressed: () => Navigator.pop(ctx),
          ),
          Expanded(
            child: Center(
              child: Text(loc.chipFolderTitle,
                  style: GoogleFonts.pressStart2p(
                      fontSize: 10, color: PetTheme.warning,
                      letterSpacing: 2)),
            ),
          ),
          Text('$total',
              style: GoogleFonts.pressStart2p(
                  fontSize: 10, color: PetTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _filterBar(AppLocalizations loc) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: PetTheme.surface,
      child: Row(
        children: [
          Text(loc.chipFolderRarity,
              style: GoogleFonts.pressStart2p(
                  fontSize: 7, color: PetTheme.textSecondary)),
          ...[null, ChipRarity.standard, ChipRarity.mega, ChipRarity.giga]
              .map((r) => _filterPill(
                    r == null ? loc.chipFolderAll : _rarityLabel(r),
                    r == null ? PetTheme.textSecondary : _rarityColor(r),
                    r == _filterRarity,
                    () => setState(() => _filterRarity = r),
                  )),
        ],
      ),
    );
  }

  Widget _filterPill(
      String label, Color color, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: active ? color : PetTheme.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label,
            style: GoogleFonts.pressStart2p(
                fontSize: 6,
                color: active ? color : PetTheme.textSecondary)),
      ),
    );
  }

  Widget _chipGrid(
      BuildContext ctx, List<BattleChip> chips, SingleplayerProvider sp, AppLocalizations loc) {
    if (chips.isEmpty) {
      return Center(
        child: Text(loc.chipFolderNoChips,
            style: GoogleFonts.pressStart2p(
                fontSize: 12, color: PetTheme.textSecondary)),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: chips.length,
      itemBuilder: (_, i) => _chipCard(ctx, chips[i], sp, i, loc),
    );
  }

  Widget _chipCard(BuildContext ctx, BattleChip chip, SingleplayerProvider sp,
      int index, AppLocalizations loc) {
    final assetPath = _assetForChip(chip);
    Widget imageWidget;
    if (assetPath != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(assetPath, width: 64, height: 64, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Text(chip.elementEmoji, style: const TextStyle(fontSize: 28))),
      );
    } else if (chip.imageUrl != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: chip.imageUrl!.startsWith('assets/')
            ? Image.asset(chip.imageUrl!, width: 64, height: 64, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Text(chip.elementEmoji, style: const TextStyle(fontSize: 28)))
            : Image.network(chip.imageUrl!, width: 64, height: 64, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Text(chip.elementEmoji, style: const TextStyle(fontSize: 28))),
      );
    } else {
      imageWidget = Column(
        children: [
          Text(chip.elementEmoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
        ],
      );
    }

    return GestureDetector(
      onLongPress: () => _showChipDetail(ctx, chip, sp, index, loc),
      child: Container(
        decoration: BoxDecoration(
          color: PetTheme.surface,
          border: Border.all(color: chip.rarityColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageWidget,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(chip.name,
                  style: GoogleFonts.pressStart2p(fontSize: 6.5, color: chip.rarityColor),
                  textAlign: TextAlign.center,
                  maxLines: 2),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chip.damage > 0
                      ? '${chip.damage}'
                      : chip.damage < 0
                          ? '+${-chip.damage}HP'
                          : '—',
                  style: GoogleFonts.pressStart2p(fontSize: 9, color: PetTheme.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: chip.rarityColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(chip.code, style: GoogleFonts.pressStart2p(fontSize: 7, color: chip.rarityColor)),
            ),
          ],
        ),
      ),
    );
  }

  void _showChipDetail(
      BuildContext ctx, BattleChip chip, SingleplayerProvider sp, int index, AppLocalizations loc) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: PetTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        side: BorderSide(color: PetTheme.border),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(chip.elementEmoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Builder(builder: (_) {
              final detailAsset = _assetForChip(chip);
              if (detailAsset != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(detailAsset, width: 96, height: 96, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                );
              } else if (chip.imageUrl != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: chip.imageUrl!.startsWith('assets/')
                      ? Image.asset(chip.imageUrl!, width: 96, height: 96, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox.shrink())
                      : Image.network(chip.imageUrl!, width: 96, height: 96, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                );
              }
              return const SizedBox.shrink();
            }),
            Text(chip.name,
                style: GoogleFonts.pressStart2p(
                    fontSize: 14, color: chip.rarityColor)),
            const SizedBox(height: 8),
            Builder(builder: (_) {
              final desc = (chip.description.trim().isEmpty || chip.description == 'Placeholder')
                ? 'No description available. Generate metadata with tools/fetch_chip_metadata.py.'
                : chip.description;
              return Text(desc,
                style: GoogleFonts.pressStart2p(
                  fontSize: 8, color: PetTheme.textSecondary,
                  height: 1.6),
                textAlign: TextAlign.center);
            }),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _detailStat('TYPE', chip.typeLabel),
                _detailStat('CLASS', chip.classLabel),
                _detailStat('ELEM', chip.elementLabel.toUpperCase()),
                _detailStat('AT', chip.atValue > 0 ? '${chip.atValue}' : '-'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PetTheme.danger,
                      side: const BorderSide(color: PetTheme.danger),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      sp.removeChip(index);
                    },
                    child: Text(loc.chipFolderDiscard,
                        style: GoogleFonts.pressStart2p(fontSize: 8)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(loc.chipFolderKeep,
                        style: GoogleFonts.pressStart2p(fontSize: 8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailStat(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.pressStart2p(
                fontSize: 6, color: PetTheme.textSecondary)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.pressStart2p(
                fontSize: 9, color: PetTheme.textPrimary)),
      ],
    );
  }

  String? _assetForChip(BattleChip chip) {
    // Prefer explicit asset URL if provided on the model.
    if (chip.imageUrl != null && chip.imageUrl!.startsWith('assets/')) return chip.imageUrl;
    // Extract the first contiguous digit group from the id (e.g. chip_123 -> 123)
    final digitMatch = RegExp(r'\d+').firstMatch(chip.id);
    if (digitMatch != null) {
      final padded = int.parse(digitMatch.group(0)!).toString().padLeft(3, '0');
      return 'assets/images/chips/BattleChip$padded.png';
    }
    return null;
  }

  String _rarityLabel(ChipRarity r) {
    switch (r) {
      case ChipRarity.standard: return 'STD';
      case ChipRarity.mega:     return 'MEGA';
      case ChipRarity.giga:     return 'GIGA';
    }
  }

  Color _rarityColor(ChipRarity r) {
    switch (r) {
      case ChipRarity.standard: return PetTheme.rarityStandard;
      case ChipRarity.mega:     return PetTheme.rarityMega;
      case ChipRarity.giga:     return PetTheme.rarityGiga;
    }
  }
}
