import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modules/singleplayer/home_screen.dart';
import '../modules/combat/combat_screen.dart';
import '../modules/bluetooth/ble_screen.dart';
import '../modules/bluetooth/ble_provider.dart';
import '../modules/singleplayer/chip_folder_screen.dart';
import '../modules/onboarding/onboarding_screen.dart';

class AppRouter {
  static const String home       = '/';
  static const String combat     = '/combat';
  static const String bluetooth  = '/bluetooth';
  static const String chipFolder = '/chips';
  static const String onboarding = '/onboarding';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return _slide(const OnboardingScreen());
      case home:
        return _slide(const HomeScreen());
      case combat:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slide(CombatScreen(isVirus: args?['isVirus'] ?? true));
      case bluetooth:
        return _slide(
          ChangeNotifierProvider(
            create: (_) => BleProvider(),
            child: const BleScreen(),
          ),
        );
      case chipFolder:
        return _slide(const ChipFolderScreen());
      default:
        return _slide(const HomeScreen());
    }
  }

  static PageRouteBuilder _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
