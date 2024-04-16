import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/models/level.dart';
import 'package:thinktank_mobile/screens/game/game_menu.dart';
import 'package:thinktank_mobile/widgets/game/level_item.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen(
      {super.key, required this.level, required this.gmaeId});

  final Level level;
  final int gmaeId;

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 30.0,
          color: Colors.white,
        ),
        toolbarHeight: 90.0,
        leading: IconButton(
          onPressed: () {
            switch (widget.gmaeId) {
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameMenuScreen(
                      game: games[0],
                    ),
                  ),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameMenuScreen(
                      game: games[1],
                    ),
                  ),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameMenuScreen(
                      game: games[2],
                    ),
                  ),
                );
                break;
              case 5:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameMenuScreen(
                      game: games[3],
                    ),
                  ),
                );
                break;
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pics/level_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: widget.level.totalLevel,
              itemBuilder: (context, index) {
                return LevelItem(
                  levelCompleted: widget.level.levelCompleted,
                  levelNumber: index + 1,
                  game: widget.level.game.name,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
