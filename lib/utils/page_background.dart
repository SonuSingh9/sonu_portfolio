import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

void setPageBackground(Color color) {
  final css = _hex(color);
  web.document.body?.style.backgroundColor = css;
  (web.document.documentElement as web.HTMLElement?)?.style.backgroundColor =
      css;
}

String _hex(Color c) {
  String h(double v) =>
      (v * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  return '#${h(c.r)}${h(c.g)}${h(c.b)}';
}
