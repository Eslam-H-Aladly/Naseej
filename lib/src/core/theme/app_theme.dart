import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);

  // Map Tailwind CSS HSL tokens from index.css to Flutter colors.
  const primary = Color(0xFF9C6B32); // hsl(25, 60%, 38%)
  const background = Color(0xFFFAF7F3); // hsl(30, 20%, 98%)
  const card = Color(0xFFF5F1EB); // hsl(30, 25%, 97%)
  const border = Color(0xFFE2D8C8); // hsl(30, 20%, 88%)

  final textTheme = GoogleFonts.tajawalTextTheme(base.textTheme).copyWith(
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: const Color(0xFF1F1B16),
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: const Color(0xFF1F1B16),
    ),
    titleLarge: GoogleFonts.tajawal(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.3,
    ),
  );

  return base.copyWith(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: const Color(0xFFFEFAF3), // primary-foreground
      secondary: const Color(0xFFF2E8D8),
      onSecondary: const Color(0xFF362A1E),
      error: const Color(0xFFDC2626),
      onError: Colors.white,
      background: background,
      onBackground: const Color(0xFF1F1B16),
      surface: card,
      onSurface: const Color(0xFF1F1B16),
      surfaceVariant: const Color(0xFFF3ECE1),
      onSurfaceVariant: const Color(0xFF6B5B46),
      outline: border,
      outlineVariant: border,
      shadow: Colors.black.withOpacity(0.08),
      scrim: Colors.black54,
      inverseSurface: const Color(0xFF111827),
      inversePrimary: const Color(0xFFF3E4D1),
      surfaceTint: primary,
    ),
    scaffoldBackgroundColor: background,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F1B16),
      ),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // radius 0.75rem ~ 12px
        side: BorderSide(color: border),
      ),
      margin: EdgeInsets.zero,
      shadowColor: Colors.black.withOpacity(0.06),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: const Color(0xFFFEFAF3),
        textStyle: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: border),
        textStyle: GoogleFonts.tajawal(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primary, width: 1.6),
      ),
      hintStyle: textTheme.bodySmall?.copyWith(
        color: const Color(0xFF6B5B46).withOpacity(0.7),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primary,
      unselectedItemColor: const Color(0xFF9CA3AF),
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 12,
      selectedLabelStyle: GoogleFonts.tajawal(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.tajawal(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);

  const primary = Color(0xFFE3B06C); // hsl(30, 55%, 50%)
  const background = Color(0xFF111827); // approx hsl(20,18%,8%)
  const card = Color(0xFF1F2933); // approx hsl(20,16%,12%)
  const border = Color(0xFF374151); // approx sidebar-border

  final textTheme = GoogleFonts.tajawalTextTheme(base.textTheme).copyWith(
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: const Color(0xFFF9FAFB),
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: const Color(0xFFF9FAFB),
    ),
  );

  return base.copyWith(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: const Color(0xFF111827),
      secondary: const Color(0xFF1F2933),
      onSecondary: const Color(0xFFF9FAFB),
      error: const Color(0xFFF87171),
      onError: Colors.black,
      background: background,
      onBackground: const Color(0xFFF9FAFB),
      surface: card,
      onSurface: const Color(0xFFF9FAFB),
      surfaceVariant: const Color(0xFF111827),
      onSurfaceVariant: const Color(0xFFD1D5DB),
      outline: border,
      outlineVariant: border,
      shadow: Colors.black.withOpacity(0.5),
      scrim: Colors.black54,
      inverseSurface: const Color(0xFFF9FAFB),
      inversePrimary: const Color(0xFF9C6B32),
      surfaceTint: primary,
    ),
    scaffoldBackgroundColor: background,
    textTheme: textTheme,
    cardTheme: CardThemeData(
      color: card,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: border,
        ),
      ),
      margin: EdgeInsets.zero,
      shadowColor: Colors.black.withOpacity(0.4),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xFF9CA3AF),
      backgroundColor: Color(0xFF020617),
      elevation: 8,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF020617),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primary, width: 1.6),
      ),
    ),
  );
}

