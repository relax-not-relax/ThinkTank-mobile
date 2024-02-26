import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/screens/authentication/registerscreen.dart';
import 'package:thinktank_mobile/screens/startscreen.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  var title1 = 'Memory challenge';
  var content1 =
      'With a collection of engaging games, we offer you diverse challenges to enhance your memory every day. By conquering these games, you\'ll boost your focus and effectively improve your ability to retain information.';
  var title2 = 'Track your progress';
  var content2 =
      'Our memory training app not only helps you play engaging games but also utilizes your scores for analysis and evaluation. We provide memory improvement charts, allowing you to easily track progress and witness clear improvements over time.';
  var title3 = 'The result of effort.';
  var content3 =
      'We help you achieve goals and reward you with interesting badges as a part of the accomplishment. You can share your achievements and progress through social media, showcasing to friends and the community your progress in enhancing your memory.';
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            PageView(
              controller: controller,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          'assets/pics/intro_1.png',
                          width: 500,
                        ),
                        Text(
                          title1,
                          style: const TextStyle(
                            color: Color.fromRGBO(45, 64, 89, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            content1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromRGBO(45, 64, 89, 0.6),
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          'assets/pics/intro_2.png',
                          width: 500,
                        ),
                        Text(
                          title2,
                          style: const TextStyle(
                            color: Color.fromRGBO(45, 64, 89, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            content2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromRGBO(45, 64, 89, 0.6),
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          'assets/pics/intro_3.png',
                          width: 500,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          title3,
                          style: const TextStyle(
                            color: Color.fromRGBO(45, 64, 89, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            content3,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromRGBO(45, 64, 89, 0.6),
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Container(
                    margin: const EdgeInsets.only(top: 250),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/pics/logoText.png',
                          width: 250,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(right: 70, left: 70),
                          child: const Text(
                            'Are you ready for your own memory journey?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(45, 64, 89, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          onPressed: () async {
                            await SharedPreferencesHelper.saveFirstUse();
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateAccountScreen()),
                              (route) => false,
                            );
                          },
                          style: buttonPrimaryPink,
                          child: const Text(
                            'Continue',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 700),
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 4,
                  effect: const WormEffect(
                    spacing: 15,
                    dotColor: Color.fromRGBO(217, 217, 217, 1),
                    activeDotColor: Color.fromRGBO(45, 64, 89, 1),
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
