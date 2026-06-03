import 'package:flutter/material.dart';

/// Exposes the page [ScrollController] to descendants so reveal-on-scroll
/// widgets can listen to scroll updates directly. (Scroll notifications only
/// bubble UP to ancestors, so children of the scroll view can't catch them.)
class ScrollProvider extends InheritedWidget {
  final ScrollController controller;

  const ScrollProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static ScrollController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ScrollProvider>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(ScrollProvider oldWidget) =>
      controller != oldWidget.controller;
}
