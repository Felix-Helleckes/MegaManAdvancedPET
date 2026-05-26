import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/app_router.dart';
import '../modules/combat/combat_provider.dart';
// removed unused import: step_service
import '../modules/singleplayer/singleplayer_provider.dart';
import 'netnavi_sprite.dart';

class PetShell extends StatefulWidget {
  const PetShell({super.key});

  @override
  State<PetShell> createState() => _PetShellState();
}

class _PetShellState extends State<PetShell> {
  int _cursorX = 0;
  int _cursorY = 0;
  bool _slotFlash = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _moveCursor(int dx, int dy) {
    setState(() {
      _cursorX += dx;
      _cursorY += dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Shell scaffold: left/right/overlay areas
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Center LCD area including Chip Slot
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Chip slot (drag target)
                  DragTarget<int>(
                    onWillAcceptWithDetails: (d) => true,
                    onAcceptWithDetails: (d) {
                      HapticFeedback.mediumImpact();
                      setState(() => _slotFlash = true);
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (!mounted) return;
                        setState(() => _slotFlash = false);
                      });
                      final sp = Provider.of<SingleplayerProvider>(context, listen: false);
                      final idx = d.data;
                      if (idx >= 0 && idx < sp.chips.length) {
                        final chip = sp.chips[idx];
                        // Start combat immediately and select the chip
                        try {
                          final combat = Provider.of<CombatProvider>(context, listen: false);
                          combat.startCombat(playerNavi: sp.navi, playerChips: sp.chips, isVirus: true);
                          combat.selectChip(chip);
                        } catch (_) {}
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Slot-In! Starting battle...')));
                        Navigator.pushNamed(context, AppRouter.combat, arguments: {'isVirus': true});
                      }
                    },
                    builder: (context, a, r) {
                      final mq = MediaQuery.of(context).size;
                      final slotW = (mq.width * 0.45).clamp(120.0, 240.0);
                      return Container(
                      width: slotW,
                      height: (slotW * 0.22).clamp(28.0, 48.0),
                      margin: EdgeInsets.only(bottom: mq.height * 0.012),
                      decoration: BoxDecoration(
                        color: _slotFlash ? Colors.greenAccent.withOpacity(0.6) : (a.isNotEmpty ? Colors.greenAccent.withOpacity(0.25) : Colors.black87),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Center(child: Text('DRAG CHIP HERE', style: TextStyle(color: Colors.white70, fontSize: 12))),
                    );
                    },
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: (MediaQuery.of(context).size.width * 0.7).clamp(220.0, 420.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1A1F),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Stack(
                      children: [
                        // NetNavi sprite animation
                        const Center(child: NetNaviSprite()),
                        // cursor indicator (kept above sprite)
                        Positioned(
                          left: (MediaQuery.of(context).size.width * 0.35) + _cursorX.toDouble() * 6,
                          top: (MediaQuery.of(context).size.width * 0.35) + _cursorY.toDouble() * 6,
                          child: const Icon(Icons.circle, size: 8, color: Colors.greenAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom D-pad and buttons
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _DPad(onMove: _moveCursor),
                    const SizedBox(width: 24),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(onPressed: () => HapticFeedback.selectionClick(), child: const Text('A')),
                        const SizedBox(height: 8),
                        ElevatedButton(onPressed: () => _openChipDrawer(context), child: const Text('B')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openChipDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chip Folder', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: Consumer<SingleplayerProvider>(
                builder: (c, sp, __) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sp.chips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    final chip = sp.chips[i];
                    return LongPressDraggable<int>(
                      data: i,
                      feedback: Opacity(
                        opacity: 0.95,
                        child: _chipWidget(chip, small: false),
                      ),
                      child: _chipWidget(chip, small: true),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Long-press a chip then drag into the slot.', style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _chipWidget(dynamic chip, {bool small = true}) {
    final size = small ? 64.0 : 96.0;
    final assetPath = _assetForChip(chip);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Builder(builder: (_) {
          if (assetPath != null) return Image.asset(assetPath, fit: BoxFit.contain);
          return Center(child: Text(chip.name ?? '', style: const TextStyle(color: Colors.white70, fontSize: 10)));
        }),
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

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green.withOpacity(0.06);
    const spacing = 6.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DPad extends StatelessWidget {
  final void Function(int dx, int dy) onMove;
  const _DPad({required this.onMove});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => onMove(0, -1), icon: const Icon(Icons.keyboard_arrow_up)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () => onMove(-1, 0), icon: const Icon(Icons.keyboard_arrow_left)),
                    const SizedBox(width: 24),
                    IconButton(onPressed: () => onMove(1, 0), icon: const Icon(Icons.keyboard_arrow_right)),
                  ],
                ),
                IconButton(onPressed: () => onMove(0, 1), icon: const Icon(Icons.keyboard_arrow_down)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
