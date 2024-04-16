import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/accountincontest.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/models/level.dart';
import 'package:thinktank_mobile/screens/contest/contest_menu.dart';
import 'package:thinktank_mobile/screens/game/level_select.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class WinScreen extends StatefulWidget {
  const WinScreen(
      {super.key,
      required this.points,
      required this.haveTime,
      this.time,
      required this.isWin,
      required this.gameId,
      required this.gameName,
      required this.contestId});
  final int points;
  final bool haveTime;
  final double? time;
  final bool isWin;
  final String gameName;
  final int gameId;
  final int? contestId;

  @override
  State<StatefulWidget> createState() {
    return WinScreenState();
  }
}

class WinScreenState extends State<WinScreen> {
  // final winSound = AudioPlayer();
  AudioPlayer au = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isWin) {
      print('play sound win');
      au.setSourceAsset('sound/wingame.mp3').then((value) {
        au.setPlayerMode(PlayerMode.mediaPlayer);
        au.play(AssetSource('sound/wingame.mp3'));
      });
      au.onPlayerComplete.listen((event) {
        au.dispose();
      });
    } else {
      au.setSourceAsset('sound/losegame.mp3').then((value) {
        au.setPlayerMode(PlayerMode.mediaPlayer);
        au.play(AssetSource('sound/losegame.mp3'));
      });
      au.onPlayerComplete.listen((event) {
        au.dispose();
      });
    }
    // winSound.setSourceAsset('sound/win.mp3');
    // loseSound.setSourceAsset('sound/lose.mp3');
    // if (widget.isWin) {
    //   winSound.play(AssetSource('sound/win.mp3'));
    // } else {
    //   loseSound.play(AssetSource('sound/lose.mp3'));
    // }
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.isWin
                ? 'assets/pics/winbg.png'
                : 'assets/pics/losebg.png'),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    widget.isWin
                        ? 'assets/pics/cup.png'
                        : 'assets/pics/cry.png',
                    width: 400,
                  ),
                ),
                Center(
                  child: Image.asset(
                    widget.isWin
                        ? 'assets/pics/wintext.png'
                        : 'assets/pics/losetext.png',
                    width: 300,
                  ),
                ),
                Visibility(
                  visible: widget.isWin,
                  child: Center(
                    child: Text(
                      '${widget.points} Points',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.haveTime,
                  child: Center(
                    child: Text(
                      '${widget.time}s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 76,
                  width: 336,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 7,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (widget.contestId != null) {
                          Contest contest =
                              (await SharedPreferencesHelper.getContests())
                                  .singleWhere((element) =>
                                      element.id == widget.contestId);
                          AccountInContest? accountInContest =
                              await ContestsAPI.checkAccountInContest(
                                  contest.id);
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContestMenuScreen(
                                        contest: contest,
                                        accountInContest: accountInContest,
                                      )),
                              (route) => false);
                        } else {
                          int levelCompleted = 0;
                          Game game = games[0];
                          switch (widget.gameId) {
                            case 1:
                              levelCompleted = await SharedPreferencesHelper
                                  .getFLipCardLevel();
                              game = games[0];
                              break;
                            case 2:
                              levelCompleted = await SharedPreferencesHelper
                                  .getMusicPasswordLevel();
                              game = games[1];
                              break;
                            case 5:
                              levelCompleted = await SharedPreferencesHelper
                                  .getAnonymousLevel();
                              game = games[3];
                              break;
                            case 4:
                              levelCompleted = await SharedPreferencesHelper
                                  .getImagesWalkthroughLevel();
                              game = games[2];
                              break;
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LevelSelectScreen(
                                        level: Level(
                                          totalLevel: 100,
                                          levelCompleted: levelCompleted,
                                          game: game,
                                        ),
                                        gmaeId: widget.gameId,
                                      )),
                              (route) => false);
                        }
                      },
                      style: widget.isWin ? buttonWinVer2(context) : buttonLose,
                      child: const Text(
                        'CONTINUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'ButtonCustomFont',
                        ),
                      ),
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
}
