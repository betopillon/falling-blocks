import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/game/coins/coins.dart';
import 'package:falling_blocks/game/game.dart';
import 'package:falling_blocks/game/hearts/heart.dart';
import 'package:falling_blocks/game/obstacle/obstacle_circle.dart';
import 'package:falling_blocks/game/obstacle/obstacle_rect.dart';
import 'package:falling_blocks/game/player/life_bar.dart';
import 'package:falling_blocks/widgets/game_over_menu.dart';
import 'package:falling_blocks/widgets/pause_btn.dart';

class Player extends PositionComponent with HasGameReference<UghGame>, CollisionCallbacks {
  Color? playerColor = Colors.white;
  Life health;

  bool playerSide = false;
  double accelaration = 0;
  double time = 0;
  double playerAngle = 0;
  double minX = 0;
  double maxX = 0;
  double padding = 13;
  double stroke = 5;
  double healthInit = 100;
  Random random = Random();
  int hitCount = 0;

  bool _playerAlive = true;
  bool get isAlive => _playerAlive;

  int _score = 0;
  int get score => _score;

  late ShapeHitbox hitbox;
  late double speed = 0;

  Player({this.playerColor, required this.health});

  @override
  Future<void>? onLoad() async {
    final defaultPaint = Paint()..color = Colors.green;

    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = false;
    add(hitbox);

    healthInit = health.width;

    return super.onLoad();
  }

  void reset() {
    _playerAlive = true;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
        size.toRect(),
        Paint()
          ..color = playerColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke);

    minX = (width / 2) + padding;
    maxX = gameRef.size.x - (width / 2 + padding);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (position.x >= minX && position.x <= maxX) {
      time += 0.2;
      position.x += time * speed;
      angle += time * playerAngle;
    }

    if (position.x < minX) {
      position.x = minX;
      angle = 0;
    }

    if (position.x > maxX) {
      position.x = maxX;
      angle = 0;
    }

    //accelaration += 0.00005;
  }

  void movePlayer() {
    time = 0;
    if (!playerSide) {
      playerSide = true;
      speed = 1 + accelaration;
      playerAngle = 0.01 + accelaration / 100;
    } else {
      playerSide = false;
      speed = -1 - accelaration;
      playerAngle = -0.01 - accelaration / 100;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    hitCount++;

    if (other is ObstacleRect || other is ObstacleCircle) {
      if (health.width < 25) {
        health.width = 0;
        destroy();
      } else {
        health.width -= 25;
      }
    }

    if (other is Heart) {
      health.width = healthInit;
    }

    if (other is Coins) {
      _score += other.type.value!;
    }
  }

  Vector2 getRandomSpaceDust() {
    return (Vector2.random(random) - Vector2.random(random)) * 200;
  }

  void destroy() {
    playerDied();

    final explosion = ParticleSystemComponent(
        particle: Particle.generate(
            count: 100,
            lifespan: 5,
            generator: (i) => AcceleratedParticle(
                speed: getRandomSpaceDust(),
                acceleration: getRandomSpaceDust(),
                child: ComputedParticle(renderer: (c, particle) {
                  final paint = Paint()..color = playerColor!;
                  paint.color = paint.color.withValues(alpha: 1 - particle.progress);
                  c.drawRect(Rect.fromLTWH(x, y, size.x / 2, size.y / 2), paint);
                }))));

    gameRef.add(explosion);
    gameRef.remove(this);

    gameRef.overlays.add(GameOverMenu.id);
    gameRef.overlays.remove(PauseButton.id);
  }

  void updateScore(int points) {
    _score += points;
  }

  void resetScore(int points) {
    _score = points;
  }

  void playerDied() {
    _playerAlive = false;
  }
}
