import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/models/accountincontest.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/game/leaderboard_user.dart';
import 'package:thinktank_mobile/widgets/game/top_user.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class LeaderBoardContestScreen extends StatefulWidget {
  const LeaderBoardContestScreen({super.key, required this.contestId});
  final int contestId;

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

  late Future _getLeaderboard;
  int pageIndex = 1;
  late ScrollController _scrollController;

  Future getLeaderboard() async {
    List<AccountInContest>? tmps =
        await ContestsAPI.getAccountInContest(widget.contestId, pageIndex, 10);
    if (tmps == null || tmps.isEmpty) return;
    switch (tmps.length) {
      case 1:
        list[0] = tmps[0];
        break;
      case 2:
        list[0] = tmps[0];
        list[1] = tmps[1];
        break;
      case 3:
        list[0] = tmps[0];
        list[1] = tmps[1];
        list[2] = tmps[2];
        break;
    }
    if (tmps.length > 3 && tmps[3].mark > 0) {
      list = tmps;
    }
    setState(() {
      list;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    setState(() {
      pageIndex = pageIndex + 1;
    });
    print("Loading more data...$pageIndex");
    List<AccountInContest>? tmps =
        await ContestsAPI.getAccountInContest(widget.contestId, pageIndex, 10);
    list.addAll(tmps!);
    if (mounted) {
      setState(() {
        list;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _getLeaderboard = getLeaderboard();
    _getLeaderboard.then((value) => {
          setState(() {
            list;
          })
        });
  }

  List<AccountInContest> list = [
    AccountInContest(
        completedTime: DateTime.now(),
        userName: "No user",
        mark: 0,
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688"),
    AccountInContest(
        completedTime: DateTime.now(),
        userName: "No user",
        mark: 0,
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688"),
    AccountInContest(
        completedTime: DateTime.now(),
        userName: "No user",
        mark: 0,
        avatar:
            "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688")
  ];

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
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
                child: (list.length > 3)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              itemCount:
                                  list.length - 3 < 0 ? 0 : list.length - 3,
                              itemBuilder: (context, index) => LeaderBoardUser(
                                  position: index + 4,
                                  userAva: list[index + 3].avatar,
                                  userName: list[index + 3].userName,
                                  point: "${list[index + 3].mark} points"),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child:
                            Image.asset('assets/pics/nomore.png', width: 300),
                      ),
              ),
            ),
            Visibility(
              visible: list[0].mark > 0,
              child: Positioned(
                top: MediaQuery.of(context).size.height * 0.1 + 25,
                left: 0,
                right: 0,
                child: TopUser(
                  userAva: list[0].avatar,
                  top: 1,
                  userName: list[0].userName,
                  point: "${list[0].mark} points",
                  isBordered: true,
                ),
              ),
            ),
            Visibility(
              visible: list[1].mark > 0,
              child: Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                left: 0,
                right: MediaQuery.of(context).size.width - 120,
                child: TopUser(
                  userAva: list[1].avatar,
                  top: 2,
                  userName: list[1].userName,
                  point: "${list[1].mark} points",
                  isBordered: true,
                ),
              ),
            ),
            Visibility(
              visible: list[2].mark > 0,
              child: Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
                left: MediaQuery.of(context).size.width - 120,
                right: 0,
                child: TopUser(
                  userAva: list[2].avatar,
                  top: 3,
                  userName: list[2].userName,
                  point: "${list[2].mark} points",
                  isBordered: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
