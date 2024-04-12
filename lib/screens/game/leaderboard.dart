import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/api/room_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountinrank.dart';
import 'package:thinktank_mobile/screens/game/game_menu.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/game/leaderboard_user.dart';
import 'package:thinktank_mobile/widgets/game/top_user.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key, required this.gameId, this.roomCode});
  final int gameId;
  final String? roomCode;

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  List<AccountInRank> accounts = [
    AccountInRank(
      accountId: 1,
      fullName: "No user",
      avatar:
          "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
      mark: 0,
      rank: 1,
    ),
    AccountInRank(
      accountId: 2,
      fullName: "No user",
      avatar:
          "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
      mark: 0,
      rank: 2,
    ),
    AccountInRank(
      accountId: 3,
      fullName: "No user",
      avatar:
          "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
      mark: 0,
      rank: 3,
    ),
  ];
  bool visibleAll = false;
  late Future _getLeaderboard;
  Future getLeaderboard() async {
    List<AccountInRank> tmps = [];
    if (widget.roomCode != null) {
      tmps = await ApiRoom.getRoomLeaderboard(widget.roomCode!);
      for (int i = 0; i < tmps.length; i++) {
        tmps[i].rank = i + 1;
      }
    } else {
      tmps = await ApiAchieviements.getLeaderBoard(widget.gameId, 1, 20);
      for (int i = 0; i < tmps.length; i++) {
        tmps[i].rank = i + 1;
      }
    }
    if (tmps.isEmpty) return;
    switch (tmps.length) {
      case 1:
        accounts[0] = tmps[0];
        break;
      case 2:
        accounts[0] = tmps[0];
        accounts[1] = tmps[1];
        break;
      case 3:
        accounts[0] = tmps[0];
        accounts[1] = tmps[1];
        accounts[2] = tmps[2];
        break;
    }
    if (tmps.length > 3) {
      accounts = tmps;
    }
    setState(() {
      accounts;
    });
  }

  String sortName(String name) {
    if (name.isEmpty) return '';
    List<String> tmp = name.split(' ');
    int lenght = tmp.length;
    if (lenght >= 3) {
      return tmp[lenght - 2] + ' ' + tmp[lenght - 1];
    }
    return name;
  }

  @override
  void initState() {
    super.initState();
    _getLeaderboard = getLeaderboard();
    _getLeaderboard.then((value) => {
          setState(() {
            visibleAll = true;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        automaticallyImplyLeading: false,
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
              if (widget.roomCode != null) {
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
                Navigator.of(context).pop();
              }
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
            Visibility(
              visible: visibleAll,
              child: Positioned(
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
                  child: (accounts.length > 3)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: accounts.length - 3 < 0
                                    ? 0
                                    : accounts.length - 3,
                                itemBuilder: (context, index) => LeaderBoardUser(
                                    position: index + 4,
                                    userAva: accounts[index + 3].avatar,
                                    userName:
                                        sortName(accounts[index + 3].fullName),
                                    point:
                                        "${accounts[index + 3].mark} points"),
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
            ),
            Visibility(
              visible:
                  visibleAll && accounts.length >= 1 && accounts[0].mark > 0,
              child: Positioned(
                top: MediaQuery.of(context).size.height * 0.1 + 25,
                left: 0,
                right: 0,
                child: TopUser(
                  userAva: accounts[0].avatar,
                  top: 1,
                  userName: sortName(accounts[0].fullName),
                  point: "${accounts[0].mark} points",
                  isBordered: true,
                ),
              ),
            ),
            Visibility(
              visible:
                  visibleAll && accounts.length >= 2 && accounts[1].mark > 0,
              child: Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                left: 0,
                right: MediaQuery.of(context).size.width - 130,
                child: TopUser(
                  userAva: accounts[1].avatar,
                  top: 2,
                  userName: sortName(accounts[1].fullName),
                  point: "${accounts[1].mark} points",
                  isBordered: true,
                ),
              ),
            ),
            Visibility(
              visible:
                  visibleAll && accounts.length >= 3 && accounts[2].mark > 0,
              child: Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
                left: MediaQuery.of(context).size.width - 130,
                right: 0,
                child: TopUser(
                  userAva: accounts[2].avatar,
                  top: 3,
                  userName: sortName(accounts[2].fullName),
                  point: "${accounts[2].mark} points",
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
