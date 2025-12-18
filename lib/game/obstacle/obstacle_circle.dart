import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/game/game.dart';
import 'package:falling_blocks/game/player/player.dart';

class ObstacleCircle extends PositionComponent with HasGameRef<UghGame>, CollisionCallbacks {
  double? speed;
  double time = 0;
  Random random = Random();
  Color obsColor = Colors.cyan;
  late bool angleRotation;
  late ShapeHitbox hitbox;

  ObstacleCircle({this.speed});

  @override
  Future<void>? onLoad() async {
    obsColor = Colors.primaries[random.nextInt(Colors.accents.length)];
    angleRotation = random.nextBool();

    final defaultPaint = Paint()..color = Colors.green;

    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = false;
    add(hitbox);

    //hitbox.debugMode = true;

    return super.onLoad();
  }

  Vector2 getRandomSpaceDust() {
    var posX = (Vector2.random(random) - Vector2.random(random)) * 20;
    return Vector2(posX.x, Vector2.random(random).y * 200);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(size.x / 1.5, size.y / 1.5), size.x / 1.5, Paint()..color = obsColor);
  }

  @override
  void update(double dt) {
    super.update(dt);

    time += 0.01;
    position.y += speed! * time * time * dt;

    if (position.y > gameRef.size.y + size.y) {
      gameRef.remove(this);

      if (gameRef.player.isAlive) {
        gameRef.player.updateScore(size.x.toInt());
      }
    }
  }

  void destroy(Set pos) {
    gameRef.remove(this);

    //gameRef.camera.shake(duration: 0.5, intensity: 5);

    final explosion = ParticleSystemComponent(
        particle: Particle.generate(
            count: 50,
            lifespan: 3,
            generator: (i) => AcceleratedParticle(
                speed: getRandomSpaceDust(),
                acceleration: getRandomSpaceDust(),
                child: ComputedParticle(renderer: (c, particle) {
                  final paint = Paint()..color = obsColor;
                  paint.color = paint.color.withOpacity(1 - particle.progress);
                  c.drawRect(Rect.fromLTWH(pos.last[0], pos.last[1], size.x / 20, size.y / 20), paint);
                }))));

    gameRef.add(explosion);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      destroy(intersectionPoints);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
