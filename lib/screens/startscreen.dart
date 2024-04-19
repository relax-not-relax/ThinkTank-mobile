import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/api/assets_api.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/api/init_api.dart';
import 'package:thinktank_mobile/api/notification_api.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';
import 'package:thinktank_mobile/models/resourceversion.dart';
import 'package:thinktank_mobile/screens/authentication/loginscreen.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/introscreen.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return StartScreenState();
  }
}

class StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  bool wait = false;
  bool visibleButton = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller2 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeInOut,
    ));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          wait = true;
        });
        displaybutton();
      }
    });
    _controller.forward();
  }

  void displaybutton() async {
    Account? acc = await ApiAuthentication.reLogin();

    if (acc != null) {
      if (acc.status == false) {
        setState(() {
          wait = false;
          visibleButton = true;
        });
        _controller2.forward();
      }
      FirebaseRealTime.setOnline(acc.id, true);
      await ApiAchieviements.getLevelOfUser(acc.id, acc.accessToken!);
      await ApiNotification.getNotifications();
      int version = await SharedPreferencesHelper.getResourceVersion();
      await AssetsAPI.addAssets(version, acc.accessToken!);
      await ContestsAPI.getContets();

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(
            inputScreen: OptionScreen(),
            screenIndex: 0,
          ),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        wait = false;
        visibleButton = true;
      });
      _controller2.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  Image.asset(
                    'assets/pics/logo.png',
                    height: 150,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SlideTransition(
                    position: _offsetAnimation,
                    child: Visibility(
                      visible: true,
                      child: Image.asset(
                        'assets/pics/logoText.png',
                        width: 200,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: wait,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15),
                      child: const CustomLoadingSpinner(
                        color: Color.fromARGB(255, 245, 149, 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Visibility(
                visible: visibleButton,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: buttonPrimaryVer2(context),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IntroScreen()),
                            );
                          },
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: buttonSecondaryVer2(context),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            'Already a member? Sign in',
                            style: TextStyle(
                                color: Color.fromRGBO(240, 123, 63, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Hủy bỏ AnimationController khi không sử dụng nữa để tránh leak memory
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
