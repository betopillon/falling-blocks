import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame_noise/flame_noise.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/game/gameHighlights/bonus_highlights.dart';
import 'package:falling_blocks/game/player/player.dart';

class Coins extends PositionComponent with HasGameRef, CollisionCallbacks {
  double speed = 1;
  double time = 0;
  Random random = Random();
  static const Color myColor1 = Colors.yellowAccent;
  static const Color myColor2 = Color.fromARGB(255, 221, 136, 0);
  late ShapeHitbox hitbox;
  late Effect scaleEffect;
  late Effect rotateEffect;
  late TextComponent dollarSign;
  late TextComponent showMeTheMoney;
  Path path = Path();
  CoinsType type;

  String? label;
  List? colors;

  Coins({required this.type});

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()..color = Colors.green;

    hitbox = CircleHitbox(radius: (size.x + 2) / 2, position: Vector2(-1, -1))
      ..paint = defaultPaint
      ..renderShape = false;
    add(hitbox);

    scaleEffect = ScaleEffect.to(Vector2(0.5, 0.5), EffectController(duration: 0.75, reverseDuration: 0.75, curve: Curves.ease, reverseCurve: Curves.easeIn, infinite: true));

    add(scaleEffect);

    dollarSign = TextComponent(text: type.label, position: Vector2(size.x / 2, size.y / 2), textRenderer: TextPaint(style: TextStyle(color: type.myColor2, fontSize: 15, fontFamily: "AmaticSC")))..anchor = Anchor.center;

    add(dollarSign);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        size.x / 2,
        Paint()
          ..color = type.myColor1!
          ..style = PaintingStyle.fill);

    canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        size.x / 2,
        Paint()
          ..color = type.myColor2!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0);
  }

  @override
  void update(double dt) {
    super.update(dt);

    time += 0.01;
    position.y += speed * time * time * dt;
    //angle += 0.05;

    if (position.y > gameRef.size.y + size.y) {
      gameRef.remove(this);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      final BonusHighlights highlight = BonusHighlights(
        label: type.label,
      )..position = position;
      gameRef.add(highlight);
      destroy(intersectionPoints);
      gameRef.remove(this);
    }
  }

  Vector2 getRandomSpaceDust() {
    return (Vector2.random(random) - Vector2.random(random)) * 100;
  }

  void destroy(Set pos) {
    gameRef.remove(this);

    //gameRef.camera.shake(duration: 0.5, intensity: 2);

    gameRef.camera.viewfinder.add(
      MoveEffect.by(
        Vector2(5, 5),
        PerlinNoiseEffectController(duration: 0.2, frequency: 400),
      ),
    );

    final explosion = ParticleSystemComponent(
        particle: Particle.generate(
            count: 50,
            lifespan: 3,
            generator: (i) => AcceleratedParticle(
                speed: getRandomSpaceDust(),
                acceleration: getRandomSpaceDust(),
                child: ComputedParticle(renderer: (c, particle) {
                  final paint = Paint()..color = type.myColor1!;
                  paint.color = paint.color.withOpacity(1 - particle.progress);
                  c.drawRect(Rect.fromLTWH(pos.last[0], pos.last[1], size.x / 20, size.y / 20), paint);
                }))));

    gameRef.add(explosion);
  }
}

class CoinsType {
  int? value;
  String? label;
  Color? myColor1;
  Color? myColor2;

  CoinsType({this.value, this.label, this.myColor1, this.myColor2});
}
