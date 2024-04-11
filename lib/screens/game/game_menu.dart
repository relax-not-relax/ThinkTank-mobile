import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/api/room_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/models/level.dart';
import 'package:thinktank_mobile/models/room.dart';
import 'package:thinktank_mobile/screens/game/battle_main_screen.dart';
import 'package:thinktank_mobile/screens/game/leaderboard.dart';
import 'package:thinktank_mobile/screens/game/level_select.dart';
import 'package:thinktank_mobile/screens/game/room/create_room_screen.dart';
import 'package:thinktank_mobile/screens/game/room/room_instruction_screen.dart';
import 'package:thinktank_mobile/screens/game/room/waiting_lobby_screen.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/game/memory_type.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
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
  final TextEditingController _controller = TextEditingController();
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  bool isJoin = false;
  List<StreamSubscription<DatabaseEvent>> listEvent = [];

  void onPlay(BuildContext context, Level level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LevelSelectScreen(level: level, gmaeId: widget.game.id),
      ),
    );
  }

  void onOpenInstruction(int gameId) {
    if (gameId != 6) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RoomInstructionScreen();
        },
      ),
    );
  }

  Future<void> onJoinRoom() async {
    _showResizableDialog(context);
    String roomCode = _controller.text;
    print(roomCode);
    isJoin = false;
    if (roomCode != "") {
      dynamic result = await ApiRoom.enterToRoom(roomCode);
      Account? account = await SharedPreferencesHelper.getInfo();
      if (result is Room) {
        // ignore: use_build_context_synchronously
        _closeDialog(context);
        listEvent.add(_databaseReference
            .child('room')
            .child(result.code)
            .onValue
            .listen((event) {
          if (event.snapshot.exists && !isJoin) {
            _databaseReference
                .child('room')
                .child(result.code)
                .child('amountPlayer')
                .onValue
                .listen((event) {
              if (event.snapshot.exists && !isJoin) {
                isJoin = true;
                int i = int.parse(event.snapshot.value.toString());
                if (i >= result.amountPlayer) {
                  print("Phòng đầy!!!");
                } else {
                  _databaseReference
                      .child('room')
                      .child(result.code)
                      .child('us${i + 1}')
                      .child('name')
                      .set(account!.userName);
                  _databaseReference
                      .child('room')
                      .child(result.code)
                      .child('us${i + 1}')
                      .child('done')
                      .set(false);
                  _databaseReference
                      .child('room')
                      .child(result.code)
                      .child('us${i + 1}')
                      .child('avt')
                      .set(account.avatar);
                  _databaseReference
                      .child('room')
                      .child(result.code)
                      .child('amountPlayer')
                      .set(i + 1);
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WaitingLobbyScreen(room: result);
                      },
                    ),
                    (route) => false,
                  );
                }
              }
            });
          } else {
            print('Phòng đã giải tán');
          }
        }));
      } else {
        // ignore: use_build_context_synchronously
        _closeDialog(context);
        Future.delayed(const Duration(seconds: 0), () {
          // ignore: use_build_context_synchronously
          _showResizableDialogError(context, result);
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (var element in listEvent) {
      element.cancel();
    }
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
                            onPressed: () async {
                              print('vo');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LeaderBoardScreen(gameId: widget.game.id),
                                ),
                              );
                            },
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

    if (widget.game.name == "Music Password" ||
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
                              onPressed: () async {
                                Account? account =
                                    await SharedPreferencesHelper.getInfo();
                                switch (widget.game.id) {
                                  case 4:
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BattleMainScreen(
                                            account: account!, gameId: 4),
                                      ),
                                    );
                                    break;
                                  case 2:
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BattleMainScreen(
                                            account: account!, gameId: 2),
                                      ),
                                    );
                                    break;
                                }
                              },
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
                              onPressed: () async {
                                print('vo');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LeaderBoardScreen(
                                        gameId: widget.game.id),
                                  ),
                                );
                              },
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

    if (widget.game.id == 6) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      child: Text(
                        "Enter room code",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(85, 0, 0, 0),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _controller,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "AWE2231",
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 218, 195, 134),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors
                                            .transparent, // Màu viền khi có focus
                                        width: 1,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 25.0,
                                      horizontal: 10.0,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 255, 223, 136),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(85, 0, 0, 0),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  onJoinRoom();
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStatePropertyAll(
                                    Size(
                                        MediaQuery.of(context).size.width - 250,
                                        70.0),
                                  ),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
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
                                  "JOIN",
                                  style: TextStyle(
                                    fontFamily: 'ButtonCustomFont',
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                              color: Color.fromARGB(85, 0, 0, 0),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CreateRoomScreen();
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(
                              Size(
                                  MediaQuery.of(context).size.width - 45, 80.0),
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
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                UniconsLine.plus_circle,
                                color: Colors.white,
                                size: 35,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "NEW ROOM",
                                style: TextStyle(
                                  fontFamily: 'ButtonCustomFont',
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                builder: (context) => const HomeScreen(
                  inputScreen: OptionScreen(),
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
            onPressed: () {
              onOpenInstruction(widget.game.id);
            },
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

void _showResizableDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 400,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/accOragne.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait...',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  'You are joining to the room party!',
                  style: TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const CustomLoadingSpinner(
                  color: Color.fromARGB(255, 245, 149, 24)),
            ],
          ),
        ),
      );
    },
  );
}

void _showResizableDialogError(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 300,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/error.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Oh no!',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
