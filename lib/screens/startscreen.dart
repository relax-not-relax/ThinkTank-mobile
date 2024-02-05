import 'package:flutter/material.dart';
import 'package:thinktank_mobile/screens/introscreen.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
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
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: Image.asset(
                'assets/pics/logo.png',
                width: 500,
              ),
            ),
            Visibility(
              visible: false,
              child: Container(
                margin: const EdgeInsets.only(bottom: 100),
                child: Image.asset(
                  'assets/pics/logoText.png',
                  width: 500,
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Container(
                  margin: const EdgeInsets.only(top: 200),
                  child: const CustomLoadingSpinner()),
            ),
            Visibility(
                child: Container(
              margin: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  ElevatedButton(
                    style: buttonPrimary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IntroScreen()),
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
                    onPressed: () {},
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
            ))
          ],
        ),
      ),
    );
  }
}
