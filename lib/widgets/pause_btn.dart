import 'package:flutter/material.dart';
import 'package:falling_blocks/game/game.dart';
import 'package:falling_blocks/widgets/pause_menu.dart';

class PauseButton extends StatelessWidget {
  static const String id = 'PauseButton';
  final UghGame gameRef;

  const PauseButton({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            IconButton(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
              icon: const Icon(Icons.pause),
              iconSize: 25,
              onPressed: () => {
                gameRef.pauseEngine(),
                gameRef.overlays.add(PauseMenu.id),
                gameRef.overlays.remove(PauseButton.id),
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Text('Pause'),
            ),
          ],
        ),
      ),
    );
  }
}
