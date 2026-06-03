import 'package:flutter/material.dart';

/// Paints text with a gradient shader.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? align;

  const GradientText(
    this.text, {
    super.key,
    required this.style,
    required this.gradient,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: align,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}
