import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/models/level.dart';
import 'package:thinktank_mobile/screens/game/level_select.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/game/memory_type.dart';
import 'package:unicons/unicons.dart';

class GameMenuScreen extends StatefulWidget {
  const GameMenuScreen({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  State<GameMenuScreen> createState() => _GameMenuScreeState();
}

class _GameMenuScreeState extends State<GameMenuScreen> {
  void onPlay(BuildContext context, Level level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LevelSelectScreen(level: level, gmaeId: widget.game.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Hero(
            tag: widget.game.id,
            child: Image.asset(
              widget.game.imageUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(0, 0, 0, 0),
                    Color.fromARGB(176, 0, 0, 0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 255,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: widget.game.name,
                          child: Text(
                            widget.game.name,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          spacing: 5.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 3.0,
                          children: [
                            for (final memonType in widget.game.type)
                              MemoryType(type: memonType),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.89,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pics/menu_bg.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(183, 0, 0, 0),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              int level = 1;
                              switch (widget.game.id) {
                                case 1:
                                  level = await SharedPreferencesHelper
                                      .getFLipCardLevel();
                                  break;
                                case 2:
                                  level = await SharedPreferencesHelper
                                      .getMusicPasswordLevel();
                                  break;
                                case 4:
                                  level = await SharedPreferencesHelper
                                      .getImagesWalkthroughLevel();
                                  break;
                                case 5:
                                  level = await SharedPreferencesHelper
                                      .getAnonymousLevel();
                                  break;
                              }
                              // ignore: use_build_context_synchronously
                              onPlay(
                                context,
                                Level(
                                  totalLevel: 100,
                                  levelCompleted: level,
                                  game: widget.game,
                                ),
                              );
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(
                                Size(MediaQuery.of(context).size.width - 45,
                                    80.0),
                              ),
                              backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 234, 67, 53),
                              ),
                              side: const MaterialStatePropertyAll(
                                BorderSide(
                                  color: Colors.white,
                                  width: 5,
                                ),
                              ),
                            ),
                            child: const Text(
                              "PLAY",
                              style: TextStyle(
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
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(183, 0, 0, 0),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(
                                Size(MediaQuery.of(context).size.width - 45,
                                    80.0),
                              ),
                              backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 85, 125, 176),
                              ),
                              side: const MaterialStatePropertyAll(
                                BorderSide(
                                  color: Colors.white,
                                  width: 5,
                                ),
                              ),
                            ),
                            child: const Text(
                              "LEADERBOARD",
                              style: TextStyle(
                                fontFamily: 'ButtonCustomFont',
                                fontSize: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.game.name == "Flip Card Challenge" ||
        widget.game.name == "Music Password" ||
        widget.game.name == "Images Walkthrough") {
      content = Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Hero(
              tag: widget.game.id,
              child: Image.asset(
                widget.game.imageUrl,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(0, 0, 0, 0),
                      Color.fromARGB(176, 0, 0, 0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 255,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: widget.game.name,
                            child: Text(
                              widget.game.name,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            spacing: 5.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: 3.0,
                            children: [
                              for (final memonType in widget.game.type)
                                MemoryType(type: memonType),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.89,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/pics/menu_bg.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(183, 0, 0, 0),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                int level = 1;
                                switch (widget.game.id) {
                                  case 1:
                                    level = await SharedPreferencesHelper
                                        .getFLipCardLevel();
                                    break;
                                  case 2:
                                    level = await SharedPreferencesHelper
                                        .getMusicPasswordLevel();
                                    break;
                                  case 4:
                                    level = await SharedPreferencesHelper
                                        .getImagesWalkthroughLevel();
                                    break;
                                  case 5:
                                    level = await SharedPreferencesHelper
                                        .getAnonymousLevel();
                                    break;
                                }
                                // ignore: use_build_context_synchronously
                                print(level);
                                print(widget.game.name);
                                print(widget.game.id);
                                onPlay(
                                  context,
                                  Level(
                                    totalLevel: 100,
                                    levelCompleted: level,
                                    game: widget.game,
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                fixedSize: MaterialStatePropertyAll(
                                  Size(MediaQuery.of(context).size.width - 45,
                                      80.0),
                                ),
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(255, 234, 67, 53),
                                ),
                                side: const MaterialStatePropertyAll(
                                  BorderSide(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "PLAY",
                                style: TextStyle(
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
                        Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(183, 0, 0, 0),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                fixedSize: MaterialStatePropertyAll(
                                  Size(MediaQuery.of(context).size.width - 45,
                                      80.0),
                                ),
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(255, 240, 123, 63),
                                ),
                                side: const MaterialStatePropertyAll(
                                  BorderSide(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "1V1 BATTLE",
                                style: TextStyle(
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
                        Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(183, 0, 0, 0),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                fixedSize: MaterialStatePropertyAll(
                                  Size(MediaQuery.of(context).size.width - 45,
                                      80.0),
                                ),
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(255, 85, 125, 176),
                                ),
                                side: const MaterialStatePropertyAll(
                                  BorderSide(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "LEADERBOARD",
                                style: TextStyle(
                                  fontFamily: 'ButtonCustomFont',
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            Account? account = await SharedPreferencesHelper.getInfo();
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  account: account!,
                  inputScreen: OptionScreen(account: account),
                  screenIndex: 0,
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 30.0,
          color: Colors.white,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: const Color.fromARGB(255, 240, 122, 63),
            ),
            child: const Icon(
              UniconsLine.question_circle,
              size: 45.0,
              color: Colors.white,
            ),
          ),
        ],
        toolbarHeight: 90.0,
      ),
      body: content,
    );
  }
}
