import 'package:canteen_mangement/core/theme/custom%20theme_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    const surface = Colors.white;
    const primary = Color(0xFF0EA5E9);
    const textMain = Color(0xFF0F172A);
    const mutedText = Color(0xFF64748B);

    final base = ThemeData.light();

    const colorScheme = ColorScheme.light(
      primary: primary,
      surface: surface,
      onPrimary: Colors.white,
      onSurface: textMain,
      secondary: Color(0xFF06B6D4),
    );

    final textTheme = GoogleFonts.poppinsTextTheme(base.textTheme)
        .copyWith(
          // Welcome Back / Join (text-2xl font-bold)
          displaySmall: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),

          // App Name (QuickerQ)
          headlineMedium: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: primary,
            letterSpacing: -0.5,
          ),

          // Section titles
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),

          // Input labels
          titleSmall: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textMain,
          ),

          // Subtitles
          bodyMedium: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: mutedText,
          ),

          // Placeholder/Muted
          bodySmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: mutedText,
          ),
        )
        .apply(bodyColor: textMain, displayColor: textMain);

    return base.copyWith(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        actionsIconTheme: IconThemeData(color: Colors.white, size: 22),
        iconTheme: IconThemeData(color: Colors.white, size: 22),
      ),
      extensions: const [AppTokens.light],

      iconTheme: const IconThemeData(color: primary),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        prefixIconColor: const Color(0xFF94A3B8),
        suffixIconColor: const Color(0xFF94A3B8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.light.rLg),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.light.rLg),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.light.rLg),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.light.rLg),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.light.rXl),
        ),
      ),
    );
  }
}
