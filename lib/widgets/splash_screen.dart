import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Animated intro on a clean white canvas: an SVG badge scales in, then
/// multilingual greetings (Hindi + English) are "written" on in a cursive
/// hand, before the gate reveals the site.
class SplashScreen extends StatefulWidget {
  final VoidCallback onGreetingsDone;
  const SplashScreen({super.key, required this.onGreetingsDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Hindi + English lead, then a couple more. Kalam renders both as handwriting.
  static const _greetings = ['नमस्ते', 'Hello', 'Hola', 'Bonjour'];
  static const _stepMs = 800;

  int _index = 0;
  bool _alive = true;

  late final AnimationController _bg = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  // Badge: scale + fade in, then a gentle continuous bob.
  late final AnimationController _badge = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat();

  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _stepMs * _greetings.length + 600),
  )..forward();

  // Drives the "write-on" reveal for each greeting.
  late final AnimationController _write = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  Future<void> _runSequence() async {
    // Let the badge appear first.
    await Future.delayed(const Duration(milliseconds: 600));
    for (int i = 0; i < _greetings.length; i++) {
      if (!_alive) return;
      setState(() => _index = i);
      _write.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: _stepMs));
    }
    await Future.delayed(const Duration(milliseconds: 250));
    if (_alive) widget.onGreetingsDone();
  }

  @override
  void dispose() {
    _alive = false;
    _bg.dispose();
    _badge.dispose();
    _bob.dispose();
    _ring.dispose();
    _progress.dispose();
    _write.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
      child: Stack(
        children: [
          // Soft pastel blobs.
          AnimatedBuilder(
            animation: _bg,
            builder: (context, _) {
              final t = _bg.value * 2 * math.pi;
              return Stack(
                children: [
                  _blob(
                    AppColors.primary,
                    0.22 + 0.08 * math.sin(t),
                    0.28 + 0.06 * math.cos(t),
                    520,
                    0.14,
                  ),
                  _blob(
                    AppColors.secondary,
                    0.78 + 0.07 * math.cos(t),
                    0.66 + 0.08 * math.sin(t),
                    480,
                    0.14,
                  ),
                  _blob(
                    AppColors.pink,
                    0.55 + 0.08 * math.sin(t * 1.3),
                    0.85 + 0.04 * math.cos(t),
                    360,
                    0.10,
                  ),
                ],
              );
            },
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _animatedBadge(),
                const SizedBox(height: 34),
                _greeting(),
              ],
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _animatedBadge() {
    return AnimatedBuilder(
      animation: Listenable.merge([_badge, _bob, _ring]),
      builder: (context, child) {
        final appear = Curves.elasticOut.transform(_badge.value.clamp(0, 1));
        final bob = (Curves.easeInOut.transform(_bob.value) - 0.5) * 12;
        return Transform.translate(
          offset: Offset(0, bob),
          child: Transform.scale(
            scale: 0.4 + 0.6 * appear,
            child: Opacity(
              opacity: _badge.value.clamp(0.0, 1.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating gradient glow ring.
                  Transform.rotate(
                    angle: _ring.value * 2 * math.pi,
                    child: Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.0),
                            AppColors.primary.withValues(alpha: 0.35),
                            AppColors.secondary.withValues(alpha: 0.35),
                            AppColors.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child!,
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 36,
              spreadRadius: -6,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: SvgPicture.asset('assets/svg/splash_badge.svg', height: 108),
      ),
    );
  }

  Widget _greeting() {
    return AnimatedBuilder(
      animation: _write,
      builder: (context, _) {
        final v = Curves.easeOut.transform(_write.value);
        return ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: v.clamp(0.02, 1.0),
            child: Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (b) => AppColors.accentDiagonal.createShader(
                  Rect.fromLTWH(0, 0, b.width, b.height),
                ),
                child: Text(
                  _greetings[_index],
                  style: GoogleFonts.kalam(
                    fontSize: 66,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 54,
      child: Column(
        children: [
          Text(
            'SONU KUMAR',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.textFaint,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 6,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: 170,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AnimatedBuilder(
                animation: _progress,
                builder: (context, _) => Stack(
                  children: [
                    Container(height: 3, color: AppColors.surfaceHi),
                    FractionallySizedBox(
                      widthFactor: _progress.value,
                      child: Container(
                        height: 3,
                        decoration: const BoxDecoration(
                          gradient: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(Color color, double dx, double dy, double size, double opacity) {
    return LayoutBuilder(
      builder: (context, c) => Positioned(
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
      ),
    );
  }
}
