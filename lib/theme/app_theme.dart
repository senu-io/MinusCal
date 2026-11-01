import 'package:flutter/material.dart';

/// Oxfords Ruleset Implementation
/// Palette: Poppy (Lead: #075431, Support: #F63434, Pop: #FCF4D2)
/// Neutrals: Ground #000000, Raised #141414, Card #1C1C1E, Line #2A2A2A
/// Font: Platform System Stack (no banned default faces)
class AppTheme {
  // Ground and Neutrals
  static const Color ground = Color(0xFF000000);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceRaised = Color(0xFF1C1C1E);
  static const Color line = Color(0xFF2A2A2A);

  static const Color text = Color(0xFFF5F5F5);
  static const Color textQuiet = Color(0xFFA3A3A3);
  static const Color textMuted = Color(0xFF6B6B6B);

  // Poppy Palette Accents
  static const Color lead = Color(0xFF075431); // Market dark green
  static const Color leadLight = Color(0xFF0E7A47);
  static const Color support = Color(0xFFF63434); // Culinary red
  static const Color pop = Color(0xFFFCF4D2); // Warm cream mark

  // State colours paired with clear words/shapes
  static const Color stateGood = Color(0xFF075431);
  static const Color stateAttention = Color(0xFFE28B00);
  static const Color stateCritical = Color(0xFFF63434);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: null, // System font stack
      scaffoldBackgroundColor: ground,
      colorScheme: const ColorScheme.dark(
        primary: lead,
        secondary: support,
        surface: surface,
        surfaceContainerHighest: surfaceRaised,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: text,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: line, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        iconTheme: IconThemeData(color: text),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: lead,
        side: const BorderSide(color: line, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: text,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: text,
          foregroundColor: ground,
          elevation: 0,
          minimumSize: const Size(48, 48), // 48dp Android target floor
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: text,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: text,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textQuiet,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
      ),
    );
  }
}
