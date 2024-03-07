import 'package:flutter/material.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';

import 'package:thinktank_mobile/models/level.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';

import 'package:thinktank_mobile/models/account.dart';

import 'package:thinktank_mobile/models/musicpassword.dart';
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
                              info: data, account: account!),
                        ),
                      );
                      break;
                    case 'Flip Card Challenge':
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlipCardGamePlay(
                            maxTime: const Duration(seconds: 10),
                            account: account!,
                            gameName: game,
                          ),
                        ),
                      );
                      break;
                    // case 'Images Walkthrough':
                    //   // ignore: use_build_context_synchronously
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => GameMainScreen(
                    //         maxTime: const Duration(seconds: 120),
                    //         account: account!,
                    //         gameName: game,
                    //       ),
                    //     ),
                    //   );
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
