import 'package:flutter/material.dart';

/// Advanced PET housing custom widget adapted from the FlutterFlow example.
/// Use `AdvancedPetHousing(width: ..., height: ...)` to render the device frame.
class AdvancedPetHousing extends StatefulWidget {
  const AdvancedPetHousing({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<AdvancedPetHousing> createState() => _AdvancedPetHousingState();
}

class _AdvancedPetHousingState extends State<AdvancedPetHousing> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 360,
      height: widget.height ?? 740,
      decoration: BoxDecoration(
        color: const Color(0xFF0F52BA), // MegaMan-like blue
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF0A3982), width: 6),
      ),
      child: Stack(
        children: [
          // Silver inlay
          Align(
            alignment: const Alignment(0, 0.3),
            child: Container(
              width: (widget.width ?? 360) * 0.85,
              height: (widget.height ?? 740) * 0.65,
              decoration: BoxDecoration(
                color: const Color(0xFFC0C0C0),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.32),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
            ),
          ),
          // Gold accent strips
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            width: 8,
            child: Container(color: const Color(0xFFD4AF37)),
          ),
          Positioned(
            top: 20,
            right: 20,
            bottom: 20,
            width: 8,
            child: Container(color: const Color(0xFFD4AF37)),
          ),
        ],
      ),
    );
  }
}
