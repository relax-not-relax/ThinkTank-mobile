import 'package:flutter/material.dart';
import 'package:thinktank_mobile/screens/authentication/loginscreen.dart';
import 'package:thinktank_mobile/screens/introscreen.dart';
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

  void displaybutton() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        wait = false;
        visibleButton = true;
      });
      _controller2.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Color.fromRGBO(40, 52, 68, 1)),
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
                  width: 250,
                ),
              ),
            ),
            Visibility(
              visible: wait,
              child: Container(
                  margin: const EdgeInsets.only(top: 200),
                  child: const CustomLoadingSpinner()),
            ),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Visibility(
                  visible: visibleButton,
                  child: Container(
                    margin: const EdgeInsets.only(top: 200),
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: buttonPrimary,
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
                          style: buttonSecondary,
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
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )),
            )
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
