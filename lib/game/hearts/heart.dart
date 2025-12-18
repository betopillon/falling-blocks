import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/game/player/player.dart';

class Heart extends PositionComponent with HasGameRef, CollisionCallbacks {
  double speed = 1;
  double time = 0;
  Random random = Random();
  Color myColor = Colors.red;
  double scaleChange = 0.01;
  Path path = Path();

  late ShapeHitbox hitbox;
  late ScaleEffect scaleEffect;

  Heart();

  @override
  Future<void>? onLoad() async {
    final defaultPaint = Paint()..color = Colors.green;

    hitbox = CircleHitbox(radius: 15, position: Vector2(-5, -3))
      ..paint = defaultPaint
      ..renderShape = false;

    scaleEffect = ScaleEffect.to(Vector2(0.5, 0.5), EffectController(duration: 0.1, reverseDuration: 1, curve: Curves.ease, reverseCurve: Curves.easeIn, infinite: true));

    speed = random.nextInt(5) + 5;

    add(scaleEffect);
    add(hitbox);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    Paint paint0 = Paint();
    paint0
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    canvas.drawCircle(Offset(size.x / 2, size.y / 1.7), 15.0, paint0);

    Paint paint1 = Paint();
    paint1
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    double width = size.x;
    double height = size.y;

    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6, 0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6, 0.5 * width, height);

    canvas.drawPath(path, paint1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    time += 0.01;
    position.y += speed * time * time * dt;

    if (position.y > gameRef.size.y + size.y) {
      gameRef.remove(this);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      destroy(intersectionPoints);
    }
  }

  Vector2 getRandomSpaceDust() {
    return (Vector2.random(random) - Vector2.random(random)) * 100;
  }

  void destroy(Set pos) {
    gameRef.remove(this);

    final explosion = ParticleSystemComponent(
        particle: Particle.generate(
            count: 20,
            lifespan: 2,
            generator: (i) => AcceleratedParticle(
                speed: getRandomSpaceDust(),
                acceleration: getRandomSpaceDust(),
                child: ComputedParticle(renderer: (c, particle) {
                  final paint = Paint()..color = myColor;
                  paint.color = paint.color.withOpacity(1 - particle.progress);
                  c.drawPath(path, paint);
                }))));
    explosion.scale = Vector2.all(explosion.scale.x / 1.5);
    explosion.position = Vector2(pos.last[0], pos.last[1]);

    gameRef.add(explosion);
  }
}
