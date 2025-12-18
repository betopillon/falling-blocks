import 'package:flutter/material.dart';
import 'package:falling_blocks/screens/game_play.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          "assets/images/logo.png",
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const GamePlay())));
              },
              icon: Image.asset("assets/images/btn_play.png"),
              iconSize: 77,
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/images/btn_edit.png"),
              iconSize: 77,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset("assets/images/btn_config.png"),
          iconSize: 50,
        ),
      ])),
    );
  }
}
