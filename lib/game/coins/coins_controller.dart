import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/game/coins/coins.dart';

class CoinsController extends Component with HasGameRef {
  late Timer _timer;
  Random random = Random();
  double speed = 200;
  double padding = 10;
  double coinInitialSize = 30;
  List<CoinsType> types = [];

  CoinsController() : super() {
    //_timer = Timer(7, onTick: _spawnCoin, repeat: true);
    _timer = Timer(1, onTick: _spawnCoin, repeat: true);
  }

  void _spawnCoin() {
    Vector2 initialSize = Vector2.all(coinInitialSize);
    Vector2 position = Vector2(0, 0);
    double r = 0;

    createCoinsTypes();

    r = random.nextInt(gameRef.size.x.toInt()).toDouble();
    if (r > gameRef.size.x / 2) {
      r -= padding + 10;
    } else {
      r += padding + 10;
    }
    position = Vector2(r, -initialSize.y * 2);

    Coins coins = Coins(type: types[random.nextInt(types.length)])
      ..size = initialSize
      ..position = position
      ..anchor = Anchor.center;

    gameRef.add(coins);
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

    gameRef.children.whereType<Coins>().forEach((coins) {
      gameRef.remove(coins);
    });

    _timer.start();
  }

  void createCoinsTypes() {
    types.add(CoinsType(value: 1000, label: "1k", myColor1: const Color.fromARGB(255, 255, 255, 255), myColor2: const Color.fromARGB(255, 89, 89, 89)));
    types.add(CoinsType(value: 2000, label: "2k", myColor1: const Color.fromARGB(255, 238, 238, 238), myColor2: const Color.fromARGB(255, 191, 144, 0)));
    types.add(CoinsType(value: 3000, label: "3k", myColor1: const Color.fromARGB(255, 255, 242, 204), myColor2: const Color.fromARGB(255, 191, 144, 0)));
    types.add(CoinsType(value: 5000, label: "5k", myColor1: const Color.fromARGB(255, 255, 217, 102), myColor2: const Color.fromARGB(255, 127, 96, 0)));
    types.add(CoinsType(value: 10000, label: "10k", myColor1: Colors.yellowAccent, myColor2: const Color.fromARGB(255, 127, 96, 0)));
  }
}
