import 'package:falling_blocks/screens/main_menu.dart';
import 'package:falling_blocks/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

final AuthService _authService = AuthService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Flame.device.fullScreen();
  Flame.device.setPortrait();

 await _authService.signInAnon();
  

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(brightness: Brightness.dark, fontFamily: 'AmaticSC', scaffoldBackgroundColor: Colors.black),
    home: const SafeArea(child: MainMenu()),
  ));
}
