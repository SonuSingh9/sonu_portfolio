import 'package:flutter/material.dart';

/// Cycles through [phrases], typing then deleting each one, with a blinking
/// caret. Pure-Dart, no external packages.
class Typewriter extends StatefulWidget {
  final List<String> phrases;
  final TextStyle style;

  const Typewriter({super.key, required this.phrases, required this.style});

  @override
  State<Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<Typewriter> {
  int _phrase = 0;
  int _chars = 0;
  bool _deleting = false;
  bool _caretOn = true;
  bool _alive = true;

  @override
  void initState() {
    super.initState();
    _tick();
    _blink();
  }

  @override
  void dispose() {
    _alive = false;
    super.dispose();
  }

  Future<void> _blink() async {
    while (_alive) {
      await Future.delayed(const Duration(milliseconds: 530));
      if (!mounted) return;
      setState(() => _caretOn = !_caretOn);
    }
  }

  Future<void> _tick() async {
    while (_alive) {
      final word = widget.phrases[_phrase];
      if (!_deleting) {
        await Future.delayed(const Duration(milliseconds: 75));
        if (!mounted) return;
        setState(() => _chars++);
        if (_chars >= word.length) {
          await Future.delayed(const Duration(milliseconds: 1100));
          _deleting = true;
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 38));
        if (!mounted) return;
        setState(() => _chars--);
        if (_chars <= 0) {
          _deleting = false;
          _phrase = (_phrase + 1) % widget.phrases.length;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.phrases[_phrase];
    final shown = word.substring(0, _chars.clamp(0, word.length));
    return RichText(
      text: TextSpan(
        style: widget.style,
        children: [
          TextSpan(text: shown),
          TextSpan(
            text: '|',
            style: widget.style.copyWith(
              color: _caretOn
                  ? widget.style.color
                  : widget.style.color?.withValues(alpha: 0),
            ),
          ),
        ],
      ),
    );
  }
}
