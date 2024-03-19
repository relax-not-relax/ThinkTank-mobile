import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';
import 'package:thinktank_mobile/models/musicpassword.dart';
import 'package:thinktank_mobile/screens/achievement/challenges_screen.dart';
import 'package:thinktank_mobile/screens/findanonymous/cardprovider.dart';
import 'package:thinktank_mobile/screens/findanonymous/findanonymous_game.dart';

import 'package:thinktank_mobile/screens/friend/addfriend_screen.dart';
import 'package:thinktank_mobile/screens/friend/friend_screen.dart';
import 'package:thinktank_mobile/screens/game/leaderboard.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/game_mainscreen.dart';

import 'package:thinktank_mobile/screens/introscreen.dart';
import 'package:thinktank_mobile/screens/startscreen.dart';
import 'package:thinktank_mobile/widgets/game/walkthrough_item.dart';
import 'package:thinktank_mobile/widgets/others/applifecycleobserver%20.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget startscreen = const CircularProgressIndicator();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (state == AppLifecycleState.paused && account != null) {
      FirebaseRealTime.setOnline(account.id, false);
    }
    if (state == AppLifecycleState.resumed && account != null) {
      FirebaseRealTime.setOnline(account.id, true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
        //home: LeaderBoardScreen(),
        // home: FindAnonymousGame(
        //   avt: 'asdv',
        //   listAnswer: [
        //     AnswerAnonymous(
        //         imageLink:
        //             'https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Farticle-1359443-0D2418FE000005DC-509_306x449.jpg?alt=media&token=e53b3a59-61a0-48ce-a941-cb86c596d15a',
        //         description: '- Williem'),
        //     AnswerAnonymous(
        //         imageLink:
        //             'https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Fbatistuta.jpg?alt=media&token=0b9374d1-5e2e-4d61-a3be-fce6ffb20552',
        //         description: '- Batistuta'),
        //   ],
        //   listAvt: const [
        //     'https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Fbatistuta.jpg?alt=media&token=0b9374d1-5e2e-4d61-a3be-fce6ffb20552',
        //     'https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Farticle-1359443-0D2418FE000005DC-509_306x449.jpg?alt=media&token=e53b3a59-61a0-48ce-a941-cb86c596d15a',
        //     'https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Fmaradona.jpg?alt=media&token=b61a55b6-90c5-4777-afbc-0a85e9e4ac4a',
        //     'https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Fthanhluong.jpg?alt=media&token=9413ea91-a12a-4476-85f1-080f8ba8f9c6',
        //   ],
        // ),
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
