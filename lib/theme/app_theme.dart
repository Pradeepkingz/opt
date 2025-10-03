import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    const accentColor = Color(0xFF2563EB);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: accentColor,
        secondary: accentColor,
        tertiary: const Color(0xFF64748B),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFF111827),
        displayColor: const Color(0xFF111827),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      cardTheme: base.cardTheme.copyWith(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        elevation: 1,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: accentColor.withOpacity(0.1),
        backgroundColor: const Color(0xFFF1F5F9),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
