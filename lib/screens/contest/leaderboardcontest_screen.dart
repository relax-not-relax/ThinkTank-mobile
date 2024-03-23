import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/game/leaderboard_user.dart';
import 'package:thinktank_mobile/widgets/game/top_user.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class LeaderBoardContestScreen extends StatefulWidget {
  const LeaderBoardContestScreen({super.key});

  @override
  State<LeaderBoardContestScreen> createState() =>
      _LeaderBoardContestScreenState();
}

class _LeaderBoardContestScreenState extends State<LeaderBoardContestScreen> {
  Future displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 15.0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 180.0,
              height: 180.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pics/cheer.png"),
                ),
              ),
            ),
            Text(
              "Yay, you have completed the contest!",
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: Text(
                "We will send notification of your ranking within 24 hours after the contest ends.",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 70, 70, 70),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 58, 82, 114),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: buttonYesBottomSheet(context),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreen(
                          inputScreen: OptionScreen(),
                          screenIndex: 0,
                        );
                      },
                    ),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Got it",
                  style: TextStyle(
                    fontFamily: 'ButtonCustomFont',
                    fontSize: 20,
                    color: Colors.white,
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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 30.0,
          color: Colors.white,
        ),
        centerTitle: true,
        title: Stack(
          children: [
            Text(
              'LEADERBOARD',
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 4.0,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 10
                  ..color = Color.fromARGB(255, 255, 153, 0),
                shadows: [
                  const Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 10.0,
                    color: Color.fromARGB(172, 0, 0, 0),
                  ),
                ],
              ),
            ),
            // Lớp văn bản chính
            Text(
              'LEADERBOARD',
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 4.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              displayBottomSheet(context);
            },
            icon: const Icon(IconlyBold.close_square),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              "assets/pics/menu_bg.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(0, 0, 0, 0),
                      Color.fromARGB(43, 0, 0, 0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: usersTest.length,
                        itemBuilder: (context, index) => LeaderBoardUser(
                            position: index + 4,
                            userAva: "assets/pics/ava_noti_test.png",
                            userName: usersTest[index],
                            point: "400 points"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1 + 25,
              left: 0,
              right: 0,
              child: const TopUser(
                userAva: "assets/pics/ava_noti_test.png",
                top: 1,
                userName: "Hoang Huy",
                point: "900 points",
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: 0,
              right: MediaQuery.of(context).size.width - 120,
              child: const TopUser(
                userAva: "assets/pics/ava_noti_test.png",
                top: 2,
                userName: "Hoang Huy",
                point: "800 points",
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.28,
              left: MediaQuery.of(context).size.width - 120,
              right: 0,
              child: const TopUser(
                userAva: "assets/pics/ava_noti_test.png",
                top: 3,
                userName: "Hoang Huy",
                point: "700 points",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
