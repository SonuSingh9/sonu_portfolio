import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(true);

class AppColors {
  static bool isDark = true;

  // ---- Brand palette: exactly 3 colors ----
  static const Color darkBase = Color(0xFF1A1210); // warm-tinted black
  static const Color cream = Color(0xFFF5ECD7); // cream
  static const Color red = Color(0xFFC0392B); // warm red

  // Accent aliases (all map to the single red accent).
  static const Color primary = red;
  static const Color secondary = red;
  static const Color teal = red;
  static const Color pink = red;

  static const LinearGradient accent = LinearGradient(
    colors: [red, red],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient accentDiagonal = LinearGradient(
    colors: [red, red],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color get bg => isDark ? darkBase : const Color(0xFFECE3CF);
  static Color get bgAlt => isDark ? darkBase : const Color(0xFFECE3CF);
  static Color get surface => isDark ? const Color(0xFF2C2420) : cream;
  static Color get surfaceHi =>
      isDark ? const Color(0xFF39312C) : const Color(0xFFE3D8BE);
  static Color get border =>
      isDark ? const Color(0xFF463E38) : const Color(0xFFCEC5B3);

  // ---- Text (mode-dependent: cream on dark, dark on cream) ----
  static Color get text => isDark ? cream : darkBase;
  static Color get textMuted =>
      isDark ? const Color(0xFFB3AB9B) : const Color(0xFF675E56);
  static Color get textFaint =>
      isDark ? const Color(0xFF7D746A) : const Color(0xFF999083);

  /// Soft elevation for cards (warm shadow in both modes).
  static List<BoxShadow> softShadow({double y = 18, double blur = 40}) {
    final c = isDark ? const Color(0xFF000000) : const Color(0xFF1A1210);
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
      textTheme: GoogleFonts.spaceGroteskTextTheme(
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
