import 'package:flutter/material.dart';

/// Lifts and scales its child on hover (desktop / web). Adds an optional glow.
class HoverLift extends StatefulWidget {
  final Widget child;
  final double scale;
  final double lift;
  final Color? glow;
  final BorderRadius? radius;

  const HoverLift({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.lift = 6,
    this.glow,
    this.radius,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, _hover ? -widget.lift : 0.0, 0.0, 1.0)
          ..scaleByDouble(
            _hover ? widget.scale : 1.0,
            _hover ? widget.scale : 1.0,
            1.0,
            1.0,
          ),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: widget.radius,
          boxShadow: _hover && widget.glow != null
              ? [
                  BoxShadow(
                    color: widget.glow!.withValues(alpha: 0.35),
                    blurRadius: 32,
                    spreadRadius: -4,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
