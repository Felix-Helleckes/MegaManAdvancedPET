import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/theme/pet_theme.dart';
import '../modules/singleplayer/singleplayer_provider.dart';
import 'netnavi_sprite.dart';

class PetShell extends StatefulWidget {
  const PetShell({super.key});

  @override
  State<PetShell> createState() => _PetShellState();
}

class _PetShellState extends State<PetShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PetTheme.background,
      body: SafeArea(
        child: _selectedIndex == 0 ? _buildPetView(context) : _buildChipsView(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: PetTheme.surface,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pet'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_3x3), label: 'Chips'),
          BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: 'BLE'),
        ],
      ),
    );
  }

  Widget _buildPetView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header: Navi status
          Consumer<SingleplayerProvider>(
            builder: (_, sp, __) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PetTheme.surface,
                border: Border.all(color: PetTheme.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    sp.navi.name,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 12,
                      color: PetTheme.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Lv.${sp.navi.level}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: PetTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Zenny: ${sp.navi.zenny}',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: PetTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // LCD Display Area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF97A98F),
                border: Border.all(color: PetTheme.border, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated sprite
                  const NetNaviSprite(),
                  // Scanlines overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ScanlinePainter(
                        lineColor: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Pet Status (Hunger/Happiness)
          Consumer<SingleplayerProvider>(
            builder: (_, sp, __) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PetTheme.surface,
                border: Border.all(color: PetTheme.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Hunger',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: PetTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: sp.petHunger / 100.0,
                          backgroundColor: PetTheme.border,
                          valueColor: AlwaysStoppedAnimation(
                            sp.petHunger > 70
                                ? PetTheme.danger
                                : sp.petHunger > 40
                                    ? PetTheme.warning
                                    : PetTheme.primary,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Happiness',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: PetTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: sp.petHappiness / 100.0,
                          backgroundColor: PetTheme.border,
                          valueColor: const AlwaysStoppedAnimation(PetTheme.accent),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => HapticFeedback.selectionClick(),
                  icon: const Icon(Icons.favorite),
                  label: Text(
                    'Feed',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => HapticFeedback.selectionClick(),
                  icon: const Icon(Icons.sports_soccer),
                  label: Text(
                    'Play',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChipsView(BuildContext context) {
    return Consumer<SingleplayerProvider>(
      builder: (_, sp, __) {
        final chips = sp.chips;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Chip Folder',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 12,
                      color: PetTheme.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${chips.length}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: PetTheme.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      await sp.clearAllChips();
                    },
                    icon: const Icon(Icons.delete_outline),
                    color: PetTheme.danger,
                    tooltip: 'Clear all chips',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Chips grid
              Expanded(
                child: chips.isEmpty
                    ? Center(
                        child: Text(
                          'No chips yet',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: PetTheme.textSecondary,
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: chips.length,
                        itemBuilder: (ctx, i) => _chipCard(chips[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chipCard(dynamic chip) {
    final assetPath = _assetForChip(chip);
    return Container(
      decoration: BoxDecoration(
        color: PetTheme.surface,
        border: Border.all(color: PetTheme.border, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetPath != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      Text('${chip.code}', style: const TextStyle(fontSize: 20)),
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  chip.code,
                  style: GoogleFonts.pressStart2p(
                    fontSize: 18,
                    color: PetTheme.accent,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              chip.name,
              style: GoogleFonts.inter(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: PetTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          if (chip.damage > 0)
            Text(
              '${chip.damage} ATK',
              style: GoogleFonts.inter(
                fontSize: 7,
                color: PetTheme.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  String? _assetForChip(dynamic chip) {
    try {
      final id = chip.id as String;
      final m = RegExp(r'^chip_(\d{3})').firstMatch(id);
      if (m != null) {
        final padded = int.parse(m.group(1)!).toString().padLeft(3, '0');
        return 'assets/images/chips/BattleChip$padded.png';
      }
    } catch (_) {}
    return null;
  }
}

class _ScanlinePainter extends CustomPainter {
  final Color lineColor;
  _ScanlinePainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = lineColor;
    const spacing = 6.0;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
