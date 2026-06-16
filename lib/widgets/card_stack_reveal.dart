import 'package:flutter/material.dart';
import 'scroll_provider.dart';

/// Animates its child in like a card being dealt onto a stack: it drops down
/// from above with a 3D hinge (rotateX), a slight scale-up and a fade. Cards in
/// a list cascade via [index], so the whole section "stacks" together the first
/// time it scrolls into view.
class CardStackReveal extends StatefulWidget {
  final Widget child;
  final int index;
  const CardStackReveal({super.key, required this.child, this.index = 0});

  @override
  State<CardStackReveal> createState() => _CardStackRevealState();
}

class _CardStackRevealState extends State<CardStackReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 760),
  );
  bool _started = false;
  ScrollController? _controller;

  void _maybeReveal() {
    if (_started || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(context).size.height;
    // Trigger once the top of the card is within 90% of the viewport.
    if (pos.dy < screenH * 0.9) {
      _started = true;
      Future.delayed(Duration(milliseconds: 110 * widget.index), () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final c = ScrollProvider.of(context);
    if (c != _controller) {
      _controller?.removeListener(_maybeReveal);
      _controller = c;
      _controller?.addListener(_maybeReveal);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeReveal());
  }

  @override
  void dispose() {
    _controller?.removeListener(_maybeReveal);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_c.value);
        final inv = 1 - t;
        final scale = 0.93 + 0.07 * t;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015) // perspective
              ..translateByDouble(0.0, inv * 64.0, 0.0, 1.0)
              ..rotateX(inv * 0.45)
              ..scaleByDouble(scale, scale, 1.0, 1.0),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
