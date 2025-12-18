import 'package:flame/game.dart';
import 'package:falling_blocks/game/game.dart';
import 'package:flutter/material.dart';
import 'package:falling_blocks/widgets/game_over_menu.dart';
import 'package:falling_blocks/widgets/pause_btn.dart';
import 'package:falling_blocks/widgets/pause_menu.dart';

UghGame ughGame = UghGame();

class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
          canPop: false,
          child: GameWidget(
            game: ughGame,
            initialActiveOverlays: const [PauseButton.id],
            overlayBuilderMap: {
              'PauseButton': (BuildContext context, UghGame gameRef) => PauseButton(gameRef: gameRef),
              'PauseMenu': (BuildContext context, UghGame gameRef) => PauseMenu(gameRef: gameRef),
              'GameOverMenu': (BuildContext context, UghGame gameRef) => GameOverMenu(gameRef: gameRef),
            },
          )),
    );
  }
}
