import 'package:flutter/material.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/screens/authentication/forgotpassscreen.dart';
import 'package:thinktank_mobile/screens/authentication/loginscreen.dart';
import 'package:thinktank_mobile/screens/authentication/registerscreen.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/introscreen.dart';
import 'package:thinktank_mobile/screens/musicpassword/musicpass_mainscreen.dart';
import 'package:thinktank_mobile/screens/startscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget startscreen = const CircularProgressIndicator();
  @override
  void initState() {
    super.initState();
    SharedPreferencesHelper.getFirstUse().then((value) {
      if (value) {
        setState(() {
          startscreen = const StartScreen();
        });
      } else {
        setState(() {
          startscreen = const IntroScreen();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0x283444),
          background: const Color.fromARGB(255, 0, 0, 0),
        ),
        useMaterial3: true,
      ),
      home: const MusicPasswordMainScreen(),
    );
  }
}
