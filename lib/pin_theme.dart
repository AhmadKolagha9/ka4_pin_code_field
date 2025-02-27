import 'package:flutter/material.dart';


class PinTheme {
  final double fieldWidth;
  final double fieldHeight;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final Color fieldBackgroundColor;
  final bool hasBackground;

  const PinTheme({
    this.fieldWidth = 50,
    this.fieldHeight = 50,
    this.border = const OutlineInputBorder(),
    this.enabledBorder,
    this.focusedBorder,
    this.fieldBackgroundColor = Colors.transparent,
    this.hasBackground = false,
  });
}