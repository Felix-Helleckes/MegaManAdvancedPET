import 'package:flutter/material.dart';

/// Simple programmatic pixel sprite with two-frame idle animation.
/// This avoids adding copyrighted art and provides an editable pixel map.
class PetSprite extends StatefulWidget {
  final double size;
  const PetSprite({super.key, this.size = 96});

  @override
  State<PetSprite> createState() => _PetSpriteState();
}

class _PetSpriteState extends State<PetSprite>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Two simple 16x16 frames using small color indices. 0 = transparent
  static const int w = 16;
  static const int h = 16;

  // Frame 0 (idle) - 16x16 MegaMan-like pose
  static const List<int> frame0 = [
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,1,2,2,2,2,2,1,0,0,0,0,0,
    0,0,0,1,2,3,2,2,2,3,2,1,0,0,0,0,
    0,0,1,2,2,3,3,3,3,3,2,2,1,0,0,0,
    0,0,1,2,3,4,4,2,2,4,4,3,2,1,0,0,
    0,1,2,2,4,4,4,2,2,4,4,4,2,2,1,0,
    0,1,2,3,4,4,4,4,4,4,4,4,3,2,1,0,
    0,1,2,3,4,4,4,4,4,4,4,4,3,2,1,0,
    0,0,1,2,2,3,3,3,3,3,2,2,1,0,0,0,
    0,0,0,1,2,2,2,2,2,2,2,1,0,0,0,0,
    0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,
    0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,
    0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,
    0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  ];

  // Frame 1 (blink / slight bob)
  static const List<int> frame1 = [
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,
    0,0,0,0,1,2,2,2,2,2,1,0,0,0,0,0,
    0,0,0,1,2,3,2,2,2,3,2,1,0,0,0,0,
    0,0,1,2,2,3,3,3,3,3,2,2,1,0,0,0,
    0,0,1,2,3,4,4,2,2,4,4,3,2,1,0,0,
    0,1,2,2,4,4,4,2,2,4,4,4,2,2,1,0,
    0,1,2,3,4,4,4,4,4,4,4,4,3,2,1,0,
    0,1,2,3,4,4,4,4,4,4,4,4,3,2,1,0,
    0,0,1,2,2,3,3,3,3,3,2,2,1,0,0,0,
    0,0,0,1,2,2,2,2,2,2,2,1,0,0,0,0,
    0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,
    0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,
    0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  ];

  // Palette: index -> color
  static const List<Color> palette = [
    Colors.transparent,
    Color(0xFF000000), // outline / black
    Color(0xFF1E5FB0), // main blue
    Color(0xFF88D6FF), // light cyan / helmet highlight
    Color(0xFFF2CCB1), // skin tone
    Color(0xFFFFFFFF), // white / eye
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pixelSize = widget.size / w;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final t = (_ctrl.value * 2).floor() % 2;
          final frame = t == 0 ? frame0 : frame1;
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _PixelPainter(frame, palette, pixelSize),
          );
        },
      ),
    );
  }
}

class _PixelPainter extends CustomPainter {
  final List<int> frame;
  final List<Color> palette;
  final double pixelSize;
  _PixelPainter(this.frame, this.palette, this.pixelSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (int y = 0; y < _PetSpriteState.h; y++) {
      for (int x = 0; x < _PetSpriteState.w; x++) {
        final idx = frame[y * _PetSpriteState.w + x];
        final color = palette[idx];
        if (color == Colors.transparent) continue;
        paint.color = color;
        final rect = Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
