import 'dart:math';
import 'package:flame/components.dart';
import 'package:falling_blocks/game/game.dart';
import 'package:falling_blocks/game/obstacle/obstacle_circle.dart';
import 'package:falling_blocks/game/obstacle/obstacle_rect.dart';

class ObstacleController extends Component with HasGameRef<UghGame> {
  late Timer _timer;
  Random random = Random();
  List side = ["left", "center", "right"];
  double speed = 75;
  double padding = 10;
  int timeElapsed = 0;
  double secondsCounter = 0;

  ObstacleController() : super() {
    _timer = Timer(1, onTick: _spawnObstacle, repeat: true);
    //_timer = Timer(10, onTick: _spawnObstacle, repeat: true);
  }

  void _spawnObstacle() {
    Vector2 initialSize = Vector2.all(40);
    Vector2 position = Vector2(0, 0);

    String obsSide = side[random.nextInt(side.length)];
    double r = 0;

    timeElapsed += (1.0 + secondsCounter).toInt();
    switch (timeElapsed) {
      case 15:
        adjustTimer(0.90);
        secondsCounter = 0.1;
        break;
      case 30:
        adjustTimer(0.80);
        secondsCounter = 0.2;
        break;
      case 60:
        adjustTimer(0.70);
        secondsCounter = 0.3;
        break;
      case 120:
        adjustTimer(0.60);
        secondsCounter = 0.4;
        break;
      case 180:
        adjustTimer(0.50);
        secondsCounter = 0.5;
        break;
      case 240:
        adjustTimer(0.40);
        secondsCounter = 0.6;
        break;
      case 300:
        adjustTimer(0.30);
        secondsCounter = 0.7;
        break;
      case 360:
        adjustTimer(0.20);
        secondsCounter = 0.8;
        break;
    }

    switch (obsSide) {
      case "left":
        {
          r = random.nextInt(50) + 50;
          initialSize = Vector2.all(r);
          position = Vector2(0 + padding + (initialSize.x / 2), -initialSize.y);
        }
        break;
      case "center":
        {
          r = random.nextInt(50) + 20;
          initialSize = Vector2.all(r);
          position = Vector2(gameRef.canvasSize.x / 2, -initialSize.y);
        }
        break;
      case "right":
        {
          r = random.nextInt(50) + 50;
          initialSize = Vector2.all(r);
          position = Vector2(gameRef.canvasSize.x - padding - (initialSize.x / 2), -initialSize.y);
        }
        break;
    }

    ObstacleRect obstacle = ObstacleRect(speed: random.nextInt(speed.toInt()).toDouble() + speed)
      ..size = initialSize
      ..position = position
      ..anchor = Anchor.center;

    gameRef.add(obstacle);
  }

  @override
  void onMount() {
    super.onMount();

    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();

    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _timer.update(dt);
    speed += 0.005;
  }

  void adjustTimer(double time, {bool restart = true}) {
    _timer.stop();
    _timer = Timer(time, onTick: _spawnObstacle, repeat: true);
    if (restart) {
      _timer.start();
    }
  }

  void reset() {
    adjustTimer(1, restart: false);
    timeElapsed = 0;
    secondsCounter = 0;
    speed = 100;

    gameRef.children.whereType<ObstacleCircle>().forEach((obstacle) {
      gameRef.remove(obstacle);
    });

    gameRef.children.whereType<ObstacleRect>().forEach((obstacle) {
      gameRef.remove(obstacle);
    });
  }
}
