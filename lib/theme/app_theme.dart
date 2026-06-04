import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide theme switch. `true` = dark (default "dark premium").
/// Toggled from the nav bar; the app root rebuilds on change.
final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(true);

/// Central design tokens. Surface/text colors switch by [isDark]; accent colors
/// are identical in both modes (so they can stay `const`).
class AppColors {
  /// Current mode. Default = dark ("dark premium"). Toggled at the app root.
  static bool isDark = true;

  // ---- Accents (same in both modes) ----
  static const Color primary = Color(0xFF7C3AED); // violet
  static const Color secondary = Color(0xFF06B6D4); // cyan
  static const Color teal = Color(0xFF14B8A6); // gradient midpoint
  static const Color pink = Color(0xFFF472B6); // decorative pop

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

  // ---- Surfaces (mode-dependent) ----
  // Dark uses near-black throughout (no grey banding); cards lift via a
  // slightly lighter surface + border + glow.
  static Color get bg =>
      isDark ? const Color(0xFF0A0A12) : const Color(0xFFFFFFFF);
  static Color get bgAlt =>
      isDark ? const Color(0xFF0A0A12) : const Color(0xFFFFFFFF);
  static Color get surface =>
      isDark ? const Color(0xFF17171F) : const Color(0xFFFFFFFF);
  static Color get surfaceHi =>
      isDark ? const Color(0xFF20202C) : const Color(0xFFF1F3F9);
  static Color get border =>
      isDark ? const Color(0xFF2A2A38) : const Color(0xFFE8EAF1);

  // ---- Text (mode-dependent) ----
  static Color get text =>
      isDark ? const Color(0xFFF4F4FB) : const Color(0xFF14132A);
  static Color get textMuted =>
      isDark ? const Color(0xFF9A9AB2) : const Color(0xFF5B6072);
  static Color get textFaint =>
      isDark ? const Color(0xFF6A6A82) : const Color(0xFF9AA0B4);

  /// Soft elevation for cards (subtler/darker on dark, soft on light).
  static List<BoxShadow> softShadow({double y = 18, double blur = 40}) {
    final c = isDark ? const Color(0xFF000000) : const Color(0xFF1B1240);
    return [
      BoxShadow(
        color: c.withValues(alpha: isDark ? 0.4 : 0.07),
        blurRadius: blur,
        spreadRadius: isDark ? -12 : -8,
        offset: Offset(0, y),
      ),
      if (!isDark)
        BoxShadow(
          color: c.withValues(alpha: 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
    ];
  }
}

class AppTheme {
  static ThemeData themed(bool dark) {
    final base = dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
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
