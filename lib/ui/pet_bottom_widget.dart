import 'package:flutter/material.dart';

class PetBottomWidget extends StatelessWidget {
  final double width;
  final double height;

  const PetBottomWidget({
    super.key,
    this.width = double.infinity,
    this.height = 260,
  });

  @override
  Widget build(BuildContext context) {
    const panelColor = Color(0xFFBFC3C6);
    const metalShade = Color(0xFF8E8E90);
    const accentBlue = Color(0xFF1E73C7);
    return Center(
      child: SizedBox(
        width: width == double.infinity ? 360 : width,
        height: height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Main metallic panel
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),

            // Small round screen cutout area (visual only)
            Positioned(
              top: 18,
              child: Container(
                width: 120,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: metalShade.withOpacity(0.6), width: 4),
                ),
              ),
            ),

            // D-Pad circle
            Positioned(
              top: 90,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
                  ],
                  border: Border.all(color: metalShade, width: 6),
                ),
                child: Center(child: _buildDpad(metalShade)),
              ),
            ),

            // Blue semicircular holder at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: (width == double.infinity ? 320 : width) - 20,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: accentBlue,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(200)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, -2)),
                    ],
                  ),
                ),
              ),
            ),

            // Small red LED / sensor
            Positioned(
              top: 170,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4)],
                  border: Border.all(color: Colors.black26, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDpad(Color metalShade) {
    // Simple cross made from four rounded rectangles
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(width: 28, height: 16, decoration: _padDecoration(metalShade)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(width: 28, height: 16, decoration: _padDecoration(metalShade)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(width: 16, height: 28, decoration: _padDecoration(metalShade)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(width: 16, height: 28, decoration: _padDecoration(metalShade)),
          ),
          // center button
          Center(
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: Colors.grey[350], shape: BoxShape.circle, border: Border.all(color: metalShade, width: 2)),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _padDecoration(Color metalShade) => BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: metalShade, width: 2),
      );
}
