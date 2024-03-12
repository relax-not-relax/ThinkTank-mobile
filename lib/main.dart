import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';
import 'package:thinktank_mobile/models/musicpassword.dart';
import 'package:thinktank_mobile/screens/achievement/achievement_screen.dart';
import 'package:thinktank_mobile/screens/findanonymous/cardprovider.dart';
import 'package:thinktank_mobile/screens/findanonymous/findanonymous_game.dart';
import 'package:thinktank_mobile/screens/introscreen.dart';
import 'package:thinktank_mobile/screens/startscreen.dart';
import 'package:thinktank_mobile/widgets/game/walkthrough_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCR9osDq8OhcwSmMW3_AlgD8KvqqlClHdE',
              appId: '1:454344962783:android:3fd8550149acb08a1b6f6a',
              messagingSenderId: '454344962783',
              projectId: 'thinktank-ad0b3'),
        )
      : await Firebase.initializeApp();
  await FirebaseMessageAPI().initNotification();
  await SharedPreferencesHelper.saveMusicPasswordLevel(1);

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
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0x283444),
            background: const Color.fromARGB(255, 0, 0, 0),
          ),
          useMaterial3: true,
        ),
        home: StartScreen(),
      ),
    );
  }
}

Future<MusicPassword> getMusicPassword(int level) async {
  List<MusicPasswordSource> listSource =
      await SharedPreferencesHelper.getMusicPasswordSources();
  List<MusicPasswordSource> listSource2 = listSource
      .where((element) =>
          element.answer.length == (((level / 10) + 4) * 2).toInt())
      .toList();
  listSource2.shuffle();
  MusicPasswordSource source = listSource2.first;
  return MusicPassword(
    level: level,
    soundLink: source.soundLink,
    answer: source.answer,
    change: 5,
    time: 600 - ((level % 10)) * 30,
  );
}
