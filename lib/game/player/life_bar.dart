import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Life extends PositionComponent with HasGameRef {
  Color? baseColor;

  Life({this.baseColor});

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = baseColor!);
  }
}
