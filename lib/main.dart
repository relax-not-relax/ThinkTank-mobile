import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/screens/friend/addfriend_screen.dart';
import 'package:thinktank_mobile/screens/friend/firend_screen.dart';
import 'package:thinktank_mobile/screens/introscreen.dart';
import 'package:thinktank_mobile/screens/startscreen.dart';

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
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0x283444),
            background: const Color.fromARGB(255, 0, 0, 0),
          ),
          useMaterial3: true,
        ),
        home: const AddFriendScreen()
        // home: const MusicPasswordGamePlay(
        //   info: MusicPassword(
        //       level: 1,
        //       soundLink:
        //           'https://firebasestorage.googleapis.com/v0/b/lottery-4803d.appspot.com/o/as1.mp3?alt=media&token=7d5c4fd4-f626-4466-aad3-e5146402eaa7',
        //       answer: 'c1e1g1c2',
        //       change: 5,
        //       time: 120),
        // ),
        //home: const FlipCardGamePlay(),
        );
  }
}
