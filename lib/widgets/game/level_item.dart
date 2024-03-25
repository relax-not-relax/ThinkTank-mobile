import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/findanonymous.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';

import 'package:thinktank_mobile/models/level.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';

import 'package:thinktank_mobile/models/account.dart';

import 'package:thinktank_mobile/models/musicpassword.dart';
import 'package:thinktank_mobile/screens/findanonymous/findanonymous_game.dart';
import 'package:thinktank_mobile/screens/flipcard/flipcard_game.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/game_mainscreen.dart';
import 'package:thinktank_mobile/screens/musicpassword/musicpassgame.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class LevelItem extends StatelessWidget {
  const LevelItem({
    super.key,
    required this.levelCompleted,
    required this.levelNumber,
    required this.game,
  });

  final int levelCompleted;
  final int levelNumber;
  final String game;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(113, 0, 0, 0),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: buttonLevel(context),
              child: Text(
                "LEVEL $levelNumber",
                style: const TextStyle(
                  fontFamily: 'ButtonCustomFont',
                  fontSize: 28,
                  color: Color.fromARGB(255, 185, 185, 185),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );

    if (levelCompleted >= levelNumber) {
      content = Column(
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  Account? account = await SharedPreferencesHelper.getInfo();
                  switch (game) {
                    case 'Music Password':
                      var data = await getMusicPassword(levelNumber);

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicPasswordGamePlay(
                              info: data, account: account!, gameName: game),
                        ),
                      );
                      break;
                    case 'Find The Anonymous':
                      var data = await geFindAnonymous(levelNumber);
                      int m = levelNumber ~/ 10 + 2;
                      print('longlong');

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FindAnonymousGame(
                              avt: account!.avatar!,
                              listAnswer: data.listAnswer,
                              level: levelNumber,
                              numberOfAnswer: m,
                              time: data.time),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => FlipCardGamePlay(
                      //       maxTime: const Duration(seconds: 10),
                      //       account: account!,
                      //       gameName: game,
                      //     ),
                      //   ),
                      // );
                      break;
                    case 'Flip Card Challenge':
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlipCardGamePlay(
                            account: account!,
                            gameName: game,
                            level: levelNumber,
                          ),
                        ),
                      );
                      break;
                    case 'Images Walkthrough':
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameMainScreen(
                            levelNumber: levelNumber,
                            account: account!,
                            gameName: game,
                            contestId: null,
                          ),
                        ),
                      );
                      break;
                  }
                },
                style: buttonLevelCompleted(context),
                child: Text(
                  "LEVEL $levelNumber",
                  style: const TextStyle(
                    fontFamily: 'ButtonCustomFont',
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    }

    return content;
  }
}

Future<MusicPassword> getMusicPassword(int level) async {
  List<MusicPasswordSource> listSource =
      await SharedPreferencesHelper.getMusicPasswordSources();
  print(listSource.first.answer.length.toString() +
      ' - ' +
      (((level / 10) + 4) * 2).toInt().toString());
  List<MusicPasswordSource> listSource2 = listSource
      .where((element) =>
          element.answer.length == (((level / 10) + 4) * 2).toInt())
      .toList();
  listSource2.shuffle();
  MusicPasswordSource source = listSource2.first;
  return MusicPassword(
    level: level,
    soundLink: source.soundLink,
    answer: source.answer,
    change: 5,
    time: 600 - ((level % 10)) * 30,
  );
}

Future<double> getTimeAnonymous(int level) async {
  int m = level ~/ 10 + 2;
  int c = (level % 10 <= 1) ? level ~/ 10 : ((level ~/ 10) + 1);
  if (level == 1)
    return (3.15 * m);
  else {
    return (await getTimeAnonymous(level - 1) -
        (3.15 - 0.48) / pow(2, c) / 10 * m);
  }
}

Future<FindAnonymous> geFindAnonymous(int level) async {
  int total = 15 + (level ~/ 10) * 5;
  int time = (await getTimeAnonymous(level)).toInt() + 3 * total;
//20s để cộng vào thời gian xem hình;
  List<FindAnonymousAsset> listSource =
      await SharedPreferencesHelper.getAnonymousAssets();
  listSource.shuffle();
  List<FindAnonymousAsset> listSource2 = listSource.getRange(0, total).toList();
  return FindAnonymous(level: level, listAnswer: listSource2, time: time);
}
