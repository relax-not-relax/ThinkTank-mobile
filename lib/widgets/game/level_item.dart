import 'package:flutter/material.dart';
import 'package:thinktank_mobile/models/musicpassword.dart';
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

    if (levelCompleted == levelNumber) {
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
                onPressed: () {
                  switch (game) {
                    case 'Music Password':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicPasswordGamePlay(
                            info: MusicPassword(
                                level: levelNumber,
                                soundLink:
                                    'https://firebasestorage.googleapis.com/v0/b/lottery-4803d.appspot.com/o/as1.mp3?alt=media&token=7d5c4fd4-f626-4466-aad3-e5146402eaa7',
                                answer: 'c1e1g1c2',
                                change: 5,
                                time: 120),
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
