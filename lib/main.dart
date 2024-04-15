import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/screens/achievement/challenges_screen.dart';
import 'package:thinktank_mobile/screens/findanonymous/cardprovider.dart';
import 'package:thinktank_mobile/screens/friend/friend_request_screen.dart';
import 'package:thinktank_mobile/screens/introscreen.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
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

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('hahaha');
      print(message.notification!.title.toString());
    }
  });

  runApp(const MyApp(
    target: '',
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.target,
  });

  final String target;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget startscreen = const CircularProgressIndicator();

  var appRoutes = {
    '/': (context) => const StartScreen(),
    '/achievement': (context) => ChallengesScreen(),
    '/request': (context) => const FriendRequestScreen(),
    '/contest': (context) => const OptionScreen(),
  };

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    Account? account = await SharedPreferencesHelper.getInfo();

    if ((state == AppLifecycleState.inactive) && account != null) {
      FirebaseRealTime.setOnline(account.id, false);
    }
    if ((state == AppLifecycleState.resumed) && account != null) {
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
        //home: StartScreen(),
        initialRoute: '/',
        routes: appRoutes,
        //home: BattleMainScreen(),
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
