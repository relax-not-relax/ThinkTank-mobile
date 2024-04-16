import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/screens/achievement/challenges_screen.dart';
import 'package:thinktank_mobile/screens/findanonymous/cardprovider.dart';
import 'package:thinktank_mobile/screens/friend/friend_request_screen.dart';
import 'package:thinktank_mobile/screens/introscreen.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/screens/startscreen.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;

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

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget startscreen = const CircularProgressIndicator();

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
    NetworkManager.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    NetworkManager.init();

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
    NetworkManager.currentContext = context;
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
