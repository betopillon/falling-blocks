import 'package:flutter/material.dart';
import 'package:falling_blocks/game/game.dart';
import 'package:falling_blocks/screens/main_menu.dart';
import 'package:falling_blocks/widgets/pause_btn.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final UghGame gameRef;

  const PauseMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          "assets/images/paused.png",
          width: 300,
          fit: BoxFit.cover,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                gameRef.overlays.add(PauseButton.id);
                gameRef.overlays.remove(PauseMenu.id);
                gameRef.resumeEngine();
              },
              icon: Image.asset("assets/images/btn_play.png"),
              iconSize: 77,
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                gameRef.restart();
                gameRef.overlays.add(PauseButton.id);
                gameRef.overlays.remove(PauseMenu.id);
                gameRef.resumeEngine();
              },
              icon: Image.asset("assets/images/btn_reset.png"),
              iconSize: 77,
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                gameRef.restart();
                gameRef.overlays.remove(PauseMenu.id);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const MainMenu())));
              },
              icon: Image.asset("assets/images/btn_exit.png"),
              iconSize: 77,
            ),
          ],
        ),
      ])),
    );
  }
}
