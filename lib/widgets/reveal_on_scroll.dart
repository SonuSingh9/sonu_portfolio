import 'package:flutter/material.dart';
import 'scroll_provider.dart';

/// Fades + slides its child into view the first time it enters the viewport.
/// Listens to the page [ScrollController] (provided via [ScrollProvider]) so it
/// works even though it lives *inside* the scroll view.
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final double offsetY;
  final Duration duration;
  final Duration delay;

  const RevealOnScroll({
    super.key,
    required this.child,
    this.offsetY = 48,
    this.duration = const Duration(milliseconds: 700),
    this.delay = Duration.zero,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  bool _shown = false;
  ScrollController? _controller;

  void _maybeReveal() {
    if (_shown || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(context).size.height;
    // Reveal when the top of the widget is within 92% of the viewport.
    if (pos.dy < screenH * 0.92) {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _shown = true);
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
    // Check once after layout (covers content already on screen at load).
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeReveal());
  }

  @override
  void dispose() {
    _controller?.removeListener(_maybeReveal);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      offset: _shown ? Offset.zero : Offset(0, widget.offsetY / 100),
      child: AnimatedOpacity(
        duration: widget.duration,
        curve: Curves.easeOut,
        opacity: _shown ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
