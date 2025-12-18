import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/game/game.dart';

class BaseScenario extends PositionComponent with HasGameRef<UghGame> {
  double padding = 10;
  Color baseColor = Colors.black45;

  BaseScenario();

  @override
  void render(Canvas canvas) {
    canvas.drawLine(
        Offset(padding, 0),
        Offset(padding, game.canvasSize.y),
        Paint()
          ..color = baseColor
          ..strokeWidth = 1);

    canvas.drawLine(
        Offset(game.canvasSize.x - padding, 0),
        Offset(game.canvasSize.x - padding, game.canvasSize.y),
        Paint()
          ..color = baseColor
          ..strokeWidth = 1);

    canvas.drawRect(Rect.fromLTRB(0, 0, padding, gameRef.size.y), Paint()..color = baseColor);

    canvas.drawRect(Rect.fromLTRB(gameRef.size.x, 0, gameRef.size.x - padding, gameRef.size.y), Paint()..color = baseColor);
  }
}
