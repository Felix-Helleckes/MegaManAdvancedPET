import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetTheme {
  // Core palette – LCD green on near-black
  static const Color background     = Color(0xFF0D1117);
  static const Color surface        = Color(0xFF161B22);
  static const Color surfaceVariant = Color(0xFF21262D);
  static const Color primary        = Color(0xFF00FF94); // neon green
  static const Color primaryDim     = Color(0xFF1D9E75);
  static const Color accent         = Color(0xFF3DBBFF); // cyber blue
  static const Color danger         = Color(0xFFFF4757);
  static const Color warning        = Color(0xFFFFD93D);
  static const Color textPrimary    = Color(0xFFE6EDF3);
  static const Color textSecondary  = Color(0xFF8B949E);
  static const Color border         = Color(0xFF30363D);

  // Chip rarity colors
  static const Color rarityStandard = Color(0xFF8B949E);
  static const Color rarityMega     = Color(0xFF3DBBFF);
  static const Color rarityGiga     = Color(0xFFFFD93D);

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: primary,
        secondary: accent,
        error: danger,
        onPrimary: Color(0xFF0D1117),
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.pressStart2pTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.pressStart2p(
          color: primary,
          fontSize: 12,
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: background,
          textStyle: GoogleFonts.pressStart2p(fontSize: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      dividerColor: border,
    );
  }
}

// Reusable pixel-art styled box decorator
BoxDecoration petBoxDecoration({
  Color? borderColor,
  Color? backgroundColor,
  double borderWidth = 1.0,
}) {
  return BoxDecoration(
    color: backgroundColor ?? PetTheme.surface,
    border: Border.all(
      color: borderColor ?? PetTheme.border,
      width: borderWidth,
    ),
    borderRadius: BorderRadius.circular(6),
  );
}
