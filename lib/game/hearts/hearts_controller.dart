import 'dart:math';
import 'package:flame/components.dart';
import 'package:falling_blocks/game/hearts/heart.dart';

class HeartsController extends Component with HasGameRef {
  late Timer _timer;
  Random random = Random();
  double speed = 200;
  double padding = 10;

  HeartsController() : super() {
    _timer = Timer(5, onTick: _spawnHeart, repeat: true);
    //_timer = Timer(1, onTick: _spawnHeart, repeat: true);
  }

  void _spawnHeart() {
    Vector2 initialSize = Vector2.all(20);
    Vector2 position = Vector2(0, 0);
    double r = 0;

    r = random.nextInt(gameRef.size.x.toInt()).toDouble();
    if (r > gameRef.size.x / 2) {
      r -= padding + 10;
    } else {
      r += padding + 10;
    }

    position = Vector2(r, -initialSize.y * 2);

    if (random.nextBool()) {
      Heart heart = Heart()
        ..size = initialSize
        ..position = position
        ..anchor = Anchor.center;

      gameRef.add(heart);
    }
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
  }

  void reset() {
    _timer.stop();

    gameRef.children.whereType<Heart>().forEach((heart) {
      gameRef.remove(heart);
    });

    _timer.start();
  }

  setTimer(double interval) {
    _timer = Timer(interval, onTick: _spawnHeart, repeat: true);
  }
}
