import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/widgets/game/leaderboard_user.dart';
import 'package:thinktank_mobile/widgets/game/top_user.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
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
            onPressed: () {},
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
              right: MediaQuery.of(context).size.width - 130,
              child: const TopUser(
                userAva: "assets/pics/ava_noti_test.png",
                top: 2,
                userName: "Hoang Huy",
                point: "800 points",
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.28,
              left: MediaQuery.of(context).size.width - 130,
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
