import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'gradient_text.dart';
import 'reveal_on_scroll.dart';

/// Responsive horizontal padding for page sections.
EdgeInsets sectionPadding(double width) {
  final h = width >= 1100
      ? (width - 1100) / 2 + 48
      : width >= 700
      ? 48.0
      : 22.0;
  return EdgeInsets.symmetric(horizontal: h, vertical: width >= 700 ? 110 : 72);
}

bool isMobile(BuildContext c) => MediaQuery.of(c).size.width < 760;

/// A standard section heading: small kicker + big gradient title.
class SectionHeader extends StatelessWidget {
  final String kicker;
  final String title;
  final CrossAxisAlignment align;

  const SectionHeader({
    super.key,
    required this.kicker,
    required this.title,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    return RevealOnScroll(
      child: Column(
        crossAxisAlignment: align,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 2,
                decoration: const BoxDecoration(gradient: AppColors.accent),
              ),
              const SizedBox(width: 10),
              Text(
                kicker.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GradientText(
            title,
            gradient: AppColors.accentDiagonal,
            style: AppTheme.display(mobile ? 32 : 44),
          ),
        ],
      ),
    );
  }
}
