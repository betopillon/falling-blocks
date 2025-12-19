import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/game/game.dart';

class Score extends PositionComponent with HasGameReference<UghGame> {
  double padding = 10;
  Color baseColor = Colors.black45;

  Score();

  @override
  void render(Canvas canvas) {}
}
