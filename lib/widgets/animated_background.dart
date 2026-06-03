import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Soft drifting pastel blobs + a faint SVG dot-grid behind all content.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: AppColors.bg)),
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final t = _c.value * 2 * math.pi;
              return Stack(
                children: [
                  _blob(
                    color: AppColors.primary,
                    dx: 0.12 + 0.05 * math.sin(t),
                    dy: 0.08 + 0.04 * math.cos(t),
                    size: 520,
                    opacity: 0.16,
                  ),
                  _blob(
                    color: AppColors.secondary,
                    dx: 0.82 + 0.05 * math.cos(t * 0.8),
                    dy: 0.26 + 0.05 * math.sin(t * 0.8),
                    size: 460,
                    opacity: 0.16,
                  ),
                  _blob(
                    color: AppColors.pink,
                    dx: 0.6 + 0.06 * math.sin(t * 1.2),
                    dy: 0.85 + 0.04 * math.cos(t * 1.2),
                    size: 420,
                    opacity: 0.12,
                  ),
                ],
              );
            },
          ),
          // Faint dot grid for texture.
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
        ],
      ),
    );
  }

  Widget _blob({
    required Color color,
    required double dx,
    required double dy,
    required double size,
    required double opacity,
  }) {
    return LayoutBuilder(
      builder: (context, c) {
        return Positioned(
          left: dx * c.maxWidth - size / 2,
          top: dy * c.maxHeight - size / 2,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: opacity),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Faint repeating dot grid that adds subtle texture to the background.
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const gap = 38.0;
    final paint = Paint()..color = AppColors.primary.withValues(alpha: 0.05);
    for (double y = 0; y < size.height; y += gap) {
      for (double x = 0; x < size.width; x += gap) {
        canvas.drawCircle(Offset(x, y), 1.3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) => false;
}
