import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';

/// Live cursor position in viewport coordinates, fed from a root-level
/// [MouseRegion] in main.dart. Null when the pointer leaves the window.
final ValueNotifier<Offset?> pointerNotifier = ValueNotifier<Offset?>(null);

/// Wraps the scrolling page [child] and paints an interactive "constellation"
/// of glowing nodes *behind* it: nodes drift, link up with nearby nodes, and
/// reach toward the cursor. The field is viewport-sized and pinned to the
/// viewport (it counter-scrolls with [controller]), so it stays dense and cheap
/// no matter how tall the page is. The content is wrapped in a [RepaintBoundary]
/// so the 60fps animation never repaints the page itself.
class ParticleNetwork extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  const ParticleNetwork({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<ParticleNetwork> createState() => _ParticleNetworkState();
}

class _ParticleNetworkState extends State<ParticleNetwork>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  final _field = _Field();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    pointerNotifier.addListener(_onPointer);
  }

  void _onPointer() => _field.pointer = pointerNotifier.value;

  void _onTick(Duration elapsed) {
    final dt = _last == Duration.zero
        ? 0.016
        : (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    _field.tick(dt.clamp(0.0, 0.05).toDouble());
  }

  @override
  void dispose() {
    pointerNotifier.removeListener(_onPointer);
    _ticker.dispose();
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _field.viewport = MediaQuery.of(context).size;
    return CustomPaint(
      painter: _NetworkPainter(_field, widget.controller),
      // The page content is cached on its own layer; the constellation repaints
      // every frame, the content only when it actually changes.
      child: RepaintBoundary(child: widget.child),
    );
  }
}

class _Particle {
  double x, y, vx, vy, r;
  _Particle(this.x, this.y, this.vx, this.vy, this.r);
}

/// Holds + advances the simulation. Acts as the painter's [Listenable] so the
/// canvas repaints once per physics tick.
class _Field extends ChangeNotifier {
  final _rnd = math.Random(7);
  final List<_Particle> ps = [];
  Size viewport = Size.zero;
  Size _seededFor = Size.zero;
  Offset? pointer;

  void _ensure(Size s) {
    if (s == _seededFor && ps.isNotEmpty) return;
    _seededFor = s;
    // Roughly one node per ~22k px², capped so large screens stay smooth.
    final target = ((s.width * s.height) / 22000).clamp(26, 96).round();
    ps.clear();
    for (var i = 0; i < target; i++) {
      ps.add(
        _Particle(
          _rnd.nextDouble() * s.width,
          _rnd.nextDouble() * s.height,
          (_rnd.nextDouble() - 0.5) * 26, // px/sec drift
          (_rnd.nextDouble() - 0.5) * 26,
          1.1 + _rnd.nextDouble() * 1.9,
        ),
      );
    }
  }

  void tick(double dt) {
    final s = viewport;
    if (s == Size.zero) return;
    _ensure(s);
    final p = pointer;
    const repelR = 175.0;
    for (final pt in ps) {
      pt.x += pt.vx * dt;
      pt.y += pt.vy * dt;
      // Wrap around the edges so the field never empties out.
      if (pt.x < 0) pt.x += s.width;
      if (pt.x > s.width) pt.x -= s.width;
      if (pt.y < 0) pt.y += s.height;
      if (pt.y > s.height) pt.y -= s.height;
      // Gently shove nodes away from the cursor.
      if (p != null) {
        final dx = pt.x - p.dx, dy = pt.y - p.dy;
        final d2 = dx * dx + dy * dy;
        if (d2 < repelR * repelR && d2 > 0.01) {
          final d = math.sqrt(d2);
          final f = (1 - d / repelR) * 38 * dt;
          pt.x += dx / d * f;
          pt.y += dy / d * f;
        }
      }
    }
    notifyListeners();
  }
}

class _NetworkPainter extends CustomPainter {
  final _Field f;
  final ScrollController controller;
  _NetworkPainter(this.f, this.controller) : super(repaint: f);

  @override
  void paint(Canvas canvas, Size size) {
    final ps = f.ps;
    if (ps.isEmpty) return;
    // Pin the field to the viewport: the CustomPaint canvas spans the whole
    // (tall) page, so shift drawing down by the current scroll offset.
    final off = controller.hasClients ? controller.offset : 0.0;
    canvas.save();
    canvas.translate(0, off);

    final accent = AppColors.red;
    final dark = AppColors.isDark;
    const linkDist = 134.0;
    final link = Paint()..strokeWidth = 1;

    // Node-to-node links, fading with distance.
    for (var i = 0; i < ps.length; i++) {
      final a = ps[i];
      for (var j = i + 1; j < ps.length; j++) {
        final b = ps[j];
        final dx = a.x - b.x, dy = a.y - b.y;
        final d2 = dx * dx + dy * dy;
        if (d2 < linkDist * linkDist) {
          final d = math.sqrt(d2);
          final alpha = (1 - d / linkDist) * (dark ? 0.45 : 0.32);
          link.color = accent.withValues(alpha: alpha);
          canvas.drawLine(Offset(a.x, a.y), Offset(b.x, b.y), link);
        }
      }
    }

    // Bright links reaching toward the cursor.
    final p = f.pointer;
    if (p != null) {
      const mDist = 215.0;
      link.strokeWidth = 1.2;
      for (final a in ps) {
        final dx = a.x - p.dx, dy = a.y - p.dy;
        final d2 = dx * dx + dy * dy;
        if (d2 < mDist * mDist) {
          final d = math.sqrt(d2);
          link.color = accent.withValues(alpha: (1 - d / mDist) * 0.6);
          canvas.drawLine(Offset(a.x, a.y), p, link);
        }
      }
    }

    // Glowing nodes.
    final glow = Paint()
      ..color = accent.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final dot = Paint()..color = accent.withValues(alpha: dark ? 0.85 : 0.6);
    for (final a in ps) {
      final c = Offset(a.x, a.y);
      canvas.drawCircle(c, a.r * 2.6, glow);
      canvas.drawCircle(c, a.r, dot);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_NetworkPainter oldDelegate) => false;
}
