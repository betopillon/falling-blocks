import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/game/hearts/hearts_controller.dart';
import 'package:falling_blocks/game/obstacle/obstacle_controller.dart';
import 'package:falling_blocks/game/coins/coins_controller.dart';
import 'package:falling_blocks/game/player/life_bar.dart';
import 'package:falling_blocks/game/player/player.dart';
import 'package:flame/components.dart';
import 'package:falling_blocks/game/scenario/base.dart';

class UghGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Player player;
  late BaseScenario baseScenario;
  late ObstacleController obsControl;
  late CoinsController coinsController;
  late Life lifeBar;
  late HeartsController heartsController;
  late TextComponent playerScore;

  bool _isLoaded = false;
  double speed = 100;
  Offset? pointerStartPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    baseScenario = BaseScenario();
    playerScore = TextComponent(text: '0', position: Vector2(size.x / 2, 100), textRenderer: TextPaint(style: const TextStyle(color: Color.fromARGB(255, 225, 0, 255), fontSize: 40, fontFamily: "AmaticSC")))..anchor = Anchor.center;

    add(playerScore);
    startGame();
    _isLoaded = true;
  }

  @override
  void onMount() {
    if (_isLoaded) {
      restart();
      resumeEngine();
    }
    super.onMount();
  }

  void startGame() {
    lifeBar = Life(baseColor: Colors.pink)
      ..width = size.x - 20
      ..height = 15
      ..position = Vector2(10, size.y - 20);
    add(lifeBar);

    player = Player(playerColor: Colors.pink, health: lifeBar)
      ..position = Vector2(size.x / 2, size.y / 2)
      ..width = 20
      ..height = 20
      ..anchor = Anchor.center;

    add(player);

    coinsController = CoinsController();
    add(coinsController);

    obsControl = ObstacleController();
    add(obsControl);

    heartsController = HeartsController();
    add(heartsController);
  }

  void restart() {
    if (!player.isAlive) {
      add(player);
      player.reset();
    }

    player.resetScore(0);
    lifeBar.width = size.x - 20;
    coinsController.reset();
    obsControl.reset();
    heartsController.reset();
  }

  @override
  void update(double dt) {
    super.update(dt);

    playerScore.text = '${player.score}';
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.movePlayer();
  }
}
