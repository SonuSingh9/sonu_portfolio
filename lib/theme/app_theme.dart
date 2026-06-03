import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design tokens + light theme for the portfolio.
class AppColors {
  // Surfaces
  static const Color bg = Color(0xFFFBFBFE); // page background
  static const Color bgAlt = Color(0xFFF3F4FB); // alternating sections
  static const Color surface = Color(0xFFFFFFFF); // cards
  static const Color surfaceHi = Color(0xFFEEF0F8); // tracks / chips
  static const Color border = Color(0xFFE7E9F3);

  // Accents
  static const Color primary = Color(0xFF7C3AED); // violet
  static const Color secondary = Color(0xFF06B6D4); // cyan
  static const Color pink = Color(0xFFF472B6);

  // Text
  static const Color text = Color(0xFF12132A);
  static const Color textMuted = Color(0xFF5B6072);
  static const Color textFaint = Color(0xFF9AA0B4);

  static const LinearGradient accent = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient accentDiagonal = LinearGradient(
    colors: [primary, pink, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Soft elevation used on cards for depth on the light background.
  static List<BoxShadow> softShadow({double y = 18, double blur = 40}) => [
    BoxShadow(
      color: const Color(0xFF1B1240).withValues(alpha: 0.06),
      blurRadius: blur,
      spreadRadius: -8,
      offset: Offset(0, y),
    ),
    BoxShadow(
      color: const Color(0xFF1B1240).withValues(alpha: 0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.interTextTheme(
        base.textTheme,
      ).apply(bodyColor: AppColors.text, displayColor: AppColors.text),
    );
  }

  static TextStyle display(double size) => GoogleFonts.spaceGrotesk(
    fontSize: size,
    fontWeight: FontWeight.w700,
    height: 1.05,
    letterSpacing: -1,
    color: AppColors.text,
  );
}
