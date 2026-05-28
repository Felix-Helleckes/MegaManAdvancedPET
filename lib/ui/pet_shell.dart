import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/app_router.dart';
import '../modules/combat/combat_provider.dart';
import '../modules/singleplayer/singleplayer_provider.dart';
import 'netnavi_sprite.dart';

// Scanline painter for LCD
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

class PetShell extends StatefulWidget {
  const PetShell({super.key});

  @override
  State<PetShell> createState() => _PetShellState();
}

class _PetShellState extends State<PetShell> {
  int _cursorX = 0;
  int _cursorY = 0;
  bool _slotFlash = false;
  int _selectedIndex = 0;
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Pet'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Chips'),
          BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: 'BLE'),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Outer skeuomorphic shell
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF083E8C), Color(0xFF2A5FB0)]), // royal blue -> lighter
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.6), offset: const Offset(0, 8), blurRadius: 18),
                    BoxShadow(color: Colors.white.withOpacity(0.06), offset: const Offset(-4, -4), blurRadius: 6, spreadRadius: -2),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: _selectedIndex == 1 ? _buildChipsView(context) : _buildPetView(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetView(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Column(
      children: [
        // LCD display
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF97A98F),
                border: Border.all(color: Colors.black, width: 6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Animated sprite centered
                  const Center(child: NetNaviSprite()),
                  // Scanlines overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ScanlinePainter(lineColor: Colors.black.withOpacity(0.05)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Buttons area
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.rotate(
                  angle: 20 * (math.pi / 180),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () => HapticFeedback.selectionClick(),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('1'),
                    ),
                  ),
                ),
                // Center D-Pad
                _DPad(onMove: _moveCursor, size: 88),
                Transform.rotate(
                  angle: -20 * (math.pi / 180),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () => _openChipDrawer(context),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('2'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipsView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Text('Chip Folder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              IconButton(
                onPressed: () async {
                  final sp = Provider.of<SingleplayerProvider>(context, listen: false);
                  await sp.clearAllChips();
                },
                icon: const Icon(Icons.delete_forever),
                tooltip: 'Alle Chips leeren',
              )
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<SingleplayerProvider>(builder: (_, sp, __) {
              final chips = sp.chips;
              if (chips.isEmpty) return const Center(child: Text('No chips', style: TextStyle(color: Colors.black54)));
              return GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: chips.map((c) => _chipWidget(c, small: true)).toList(),
              );
            }),
          )
        ],
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
  final double size;
  const _DPad({required this.onMove, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final iconConstraint = (size * 0.28).clamp(20.0, 36.0);
    final iconSz = (size * 0.18).clamp(14.0, 24.0);
    return SizedBox(
      width: size,
      height: size,
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
                IconButton(
                  onPressed: () => onMove(0, -1),
                  icon: const Icon(Icons.keyboard_arrow_up),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(width: iconConstraint, height: iconConstraint),
                  iconSize: iconSz,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => onMove(-1, 0),
                      icon: const Icon(Icons.keyboard_arrow_left),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(width: iconConstraint, height: iconConstraint),
                      iconSize: iconSz,
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () => onMove(1, 0),
                      icon: const Icon(Icons.keyboard_arrow_right),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(width: iconConstraint, height: iconConstraint),
                      iconSize: iconSz,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => onMove(0, 1),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(width: iconConstraint, height: iconConstraint),
                  iconSize: iconSz,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
