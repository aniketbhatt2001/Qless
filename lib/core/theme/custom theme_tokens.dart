import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  // Utility colors (not part of Material ColorScheme)
  final Color mutedText; // #64748B
  final Color borderLight; // rgba(0, 0, 0, 0.1)
  final Color inactiveIcon; // #94a3b8

  // Radii
  final double rSm;
  final double rMd;
  final double rLg;
  final double rXl;
  final double rFull;

  // Shadows
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> buttonShadow;

  const AppTokens({
    required this.mutedText,
    required this.borderLight,
    required this.inactiveIcon,
    required this.rSm,
    required this.rMd,
    required this.rLg,
    required this.rXl,
    required this.rFull,
    required this.cardShadow,
    required this.buttonShadow,
  });

  static const light = AppTokens(
    mutedText: Color(0xFF64748B),
    borderLight: Color(0x1A000000),
    inactiveIcon: Color(0xFF94A3B8),

    rSm: 8,
    rMd: 10,
    rLg: 12,
    rXl: 24,
    rFull: 9999,

    cardShadow: [
      BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, 4)),
    ],
    buttonShadow: [
      BoxShadow(color: Color(0x400EA5E9), blurRadius: 15, offset: Offset(0, 4)),
    ],
  );

  @override
  AppTokens copyWith({
    Color? mutedText,
    Color? borderLight,
    Color? inactiveIcon,
    double? rSm,
    double? rMd,
    double? rLg,
    double? rXl,
    double? rFull,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? buttonShadow,
  }) {
    return AppTokens(
      mutedText: mutedText ?? this.mutedText,
      borderLight: borderLight ?? this.borderLight,
      inactiveIcon: inactiveIcon ?? this.inactiveIcon,
      rSm: rSm ?? this.rSm,
      rMd: rMd ?? this.rMd,
      rLg: rLg ?? this.rLg,
      rXl: rXl ?? this.rXl,
      rFull: rFull ?? this.rFull,
      cardShadow: cardShadow ?? this.cardShadow,
      buttonShadow: buttonShadow ?? this.buttonShadow,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;

    return AppTokens(
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      inactiveIcon: Color.lerp(inactiveIcon, other.inactiveIcon, t)!,
      rSm: lerpDouble(rSm, other.rSm, t)!,
      rMd: lerpDouble(rMd, other.rMd, t)!,
      rLg: lerpDouble(rLg, other.rLg, t)!,
      rXl: lerpDouble(rXl, other.rXl, t)!,
      rFull: lerpDouble(rFull, other.rFull, t)!,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      buttonShadow: t < 0.5 ? buttonShadow : other.buttonShadow,
    );
  }
}

extension ThemeTokensX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}
