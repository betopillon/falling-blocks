import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class BonusHighlights extends PositionComponent with HasGameRef {
  late Effect scaleEffect;
  late Effect fadeEffect;
  late TextComponent labelText;

  int alpha = 255;
  String? label;
  Vector2? pos;

  BonusHighlights({this.label});

  @override
  Future<void>? onLoad() async {
    labelText = TextComponent(text: label, position: Vector2(size.x / 2, size.y / 2), textRenderer: TextPaint(style: const TextStyle(color: Color.fromARGB(255, 255, 200, 0), fontSize: 20, fontFamily: "AmaticSC")))..anchor = Anchor.center;

    add(labelText);

    scaleEffect = MoveByEffect(
      Vector2(0, -20),
      EffectController(duration: 2, curve: Curves.easeOut, infinite: false),
      onComplete: destroy,
    );

    add(scaleEffect);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    alpha -= 5;

    if (alpha > 0) {
      labelText.textRenderer = TextPaint(style: TextStyle(color: Color.fromARGB(alpha, 255, 213, 0), fontSize: 20, fontFamily: "AmaticSC"));
      super.update(dt);
    }
  }

  void destroy() {
    gameRef.remove(this);
  }
}
