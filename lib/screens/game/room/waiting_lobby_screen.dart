import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/api/room_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/account_in_room.dart';
import 'package:thinktank_mobile/models/flipcard.dart';
import 'package:thinktank_mobile/models/room.dart';
import 'package:thinktank_mobile/screens/flipcard/flipcard_game.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/game_mainscreen.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/appbar/room_appbar.dart';
import 'package:thinktank_mobile/widgets/game/user_chip.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class WaitingLobbyScreen extends StatefulWidget {
  const WaitingLobbyScreen({
    super.key,
    required this.room,
    required this.gameId,
  });

  final Room room;
  final int gameId;

  @override
  State<WaitingLobbyScreen> createState() => _WaitingLobbyScreenState();
}

class _WaitingLobbyScreenState extends State<WaitingLobbyScreen> {
  bool? isOwner;
  late Future _initData;
  Account? account;
  int? topicId;
  int index = 0;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<AccountInRoom> listMembers = [];
  List<StreamSubscription<DatabaseEvent>> listEvent = [];
  Future<bool> getData() async {
    account = await SharedPreferencesHelper.getInfo();
    for (AccountInRoom _account in widget.room.accountInRoomResponses) {
      if (account!.id == _account.accountId) {
        return _account.isAdmin;
      }
    }

    return false;
  }

  @override
  void initState() {
    super.initState();

    _initData = getData();
    _initData.then((value) {
      listEvent.add(_databaseReference
          .child('room')
          .child(widget.room.code)
          .onValue
          .listen((event) {
        if (!event.snapshot.exists &&
            mounted &&
            event.snapshot.value.toString() == '-1') {
          _showResizableDialog(context);
          Future.delayed(const Duration(seconds: 4)).then((value) {
            if (mounted) {
              _closeDialog(context);
            }
            if (mounted) {
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
            }
          });
        }
        if (!event.snapshot.exists && mounted) {
          _showResizableDialog(context);
          Future.delayed(const Duration(seconds: 4)).then((value) {
            if (mounted) {
              _closeDialog(context);
            }
            if (mounted) {
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
            }
          });
        }
        if (topicId == null &&
            event.snapshot.child('topicId').exists &&
            mounted) {
          topicId = int.parse(event.snapshot.child('topicId').value.toString());
        }

        listMembers.clear();
        for (int i = 1; i < 6; i++) {
          if (event.snapshot.hasChild('us$i') &&
              event.snapshot.child('us$i').child('name').value.toString() !=
                  account!.userName &&
              mounted) {
            AccountInRoom accountInRoom = AccountInRoom(
                id: i,
                isAdmin: false,
                accountId: 0,
                username:
                    event.snapshot.child('us$i').child('name').value.toString(),
                roomId: 0,
                duration: 0,
                mark: 0,
                pieceOfInformation: 0,
                avatar:
                    event.snapshot.child('us$i').child('avt').value.toString());
            listMembers.add(accountInRoom);
          }
          if (event.snapshot.hasChild('us$i') &&
              event.snapshot.child('us$i').child('name').value.toString() ==
                  account!.userName &&
              mounted) {
            index = i;
          }
        }

        setState(() {
          listMembers;
          index;
        });
      }));
      setState(() {
        isOwner = value;
        print(isOwner);
      });

      if (!isOwner!) {
        listEvent.add(_databaseReference
            .child('room')
            .child(widget.room.code)
            .child('amountPlayer')
            .onValue
            .listen((event) {
          if (event.snapshot.exists &&
              int.parse(event.snapshot.value.toString()) == -1 &&
              mounted) {
            switch (widget.gameId) {
              case 4:
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameMainScreen(
                        account: account!,
                        gameName: 'Image Walkthrough',
                        levelNumber: 0,
                        contestId: null,
                        roomCode: widget.room.code,
                        topicId: topicId),
                  ),
                  (route) => false,
                );
                break;
              case 1:
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlipCardGamePlay(
                        account: account!,
                        gameName: 'Flipcard',
                        level: 0,
                        roomCode: widget.room.code,
                        topicId: topicId),
                  ),
                  (route) => false,
                );
                break;
            }
          }
        }));
      }
    });
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
    NetworkManager.currentContext = context;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TRoomAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.23,
        room: widget.room,
        isOwner: isOwner ?? false,
        index: index,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pics/menu_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                14,
                MediaQuery.of(context).size.height * 0.15,
                14,
                0,
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            spacing: 15.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: 15.0,
                            children: [
                              //usersRoomTest dùng để test UI
                              for (final acc in listMembers)
                                UserChip(accountInRoom: acc),

                              //sử dụng list user có trong Room
                              //for (final acc in widget.room.accountInRoomResponses)
                              //UserChip(accountInRoom: acc),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: Center(
                                child: Text(
                                  "Waiting for other players...",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              child: const Center(
                                child: CustomLoadingSpinner(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isOwner == true
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 35,
                      ),
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width - 80,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 40, 52, 68),
                                blurRadius: 0,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              Account? account =
                                  await SharedPreferencesHelper.getInfo();
                              if (listMembers.isEmpty) {
                                print("Chua du nguoi");
                              } else {
                                ApiRoom.startGame(widget.room.code, 165);
                                ApiRoom.removeRoomDelay(widget.room.code, 180);
                                await _databaseReference
                                    .child('room')
                                    .child(widget.room.code)
                                    .child('amountPlayer')
                                    .set(-1);
                                await _databaseReference
                                    .child('room')
                                    .child(widget.room.code)
                                    .child('AmountPlayerDone')
                                    .set(0);
                                switch (widget.gameId) {
                                  case 4:
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameMainScreen(
                                            account: account!,
                                            gameName: 'Image Walkthrough',
                                            levelNumber: 0,
                                            contestId: null,
                                            roomCode: widget.room.code,
                                            topicId: topicId),
                                      ),
                                      (route) => false,
                                    );
                                    break;
                                  case 1:
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FlipCardGamePlay(
                                            account: account!,
                                            gameName: 'Flipcard',
                                            level: 0,
                                            roomCode: widget.room.code,
                                            topicId: topicId),
                                      ),
                                      (route) => false,
                                    );
                                    break;
                                }
                              }
                            },
                            style: button1v1,
                            child: const Text(
                              'START NOW',
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
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
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
                'Room is cancelled by owner',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Please wait a moment...',
                style: TextStyle(
                    color: Color.fromRGBO(129, 140, 155, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
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
