import 'package:flutter/material.dart';

class PetFrame extends StatelessWidget {
  final Widget child;
  const PetFrame({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/ux/overlay.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: const Center(child: Text('PET Frame Error')),
              );
            },
          ),
        ),
        child,
      ],
    );
  }
}