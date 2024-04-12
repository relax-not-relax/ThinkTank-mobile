import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/api/room_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/flipcard.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/screens/contest/finalresult_screen.dart';
import 'package:thinktank_mobile/screens/game/leaderboard.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:thinktank_mobile/widgets/others/winscreen.dart';

class FlipCardGamePlay extends StatefulWidget {
  const FlipCardGamePlay({
    super.key,
    required this.account,
    required this.gameName,
    required this.level,
    this.contestId,
    this.roomCode,
    this.topicId,
  });

  final Account account;
  final String gameName;
  final int level;
  final int? contestId;
  final String? roomCode;
  final int? topicId;

  @override
  State<FlipCardGamePlay> createState() => _FlipCardGamePlayState();
}

class _FlipCardGamePlayState extends State<FlipCardGamePlay> {
  Timer? timer;
  late int levelNow;
  Duration remainingTime = Duration(
    seconds: 0,
  );
  Duration maxTime = Duration(
    seconds: 0,
  );
  late FlipCardGame _game;
  List<GlobalKey<FlipCardState>> cardKeys = [];
  List<GlobalKey<FlipCardState>> checkCardKeys = [];
  bool _timerStarted = false;
  int count = 0;
  double percent = 0.0;
  bool isNotaddAccountInRoom = true;
  final progressTitle = "Flipped";
  int total = 0;
  int pair = 0;
  int indexCheck = -1;
  bool continueVisible = false;
  bool isLosed = false;
  bool _isCheckingCards = false;
  int numberPlayer = 0;
  bool _isLoading = true;
  bool _isFree = true;
  AudioPlayer au = AudioPlayer();

  bool _areAllCardsFlipped() {
    print(_game.matchedCards.every((isFlipped) => false));
    return _game.matchedCards.every((isFlipped) => false);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() {
          final newTime = remainingTime - const Duration(milliseconds: 500);
          if (newTime.isNegative) {
            timer!.cancel();
            if (mounted) {
              setState(() {
                isLosed = true;
                continueVisible = true;
              });
            }
          } else {
            remainingTime = newTime;
          }
        });
      }
    });
  }

  void win() async {
    double points = (remainingTime.inMilliseconds / 1000);
    if (widget.contestId == null && widget.roomCode == null) {
      int levelMax = await SharedPreferencesHelper.getFLipCardLevel();
      if (levelMax == widget.level) {
        await SharedPreferencesHelper.saveFLipCardLevel(widget.level + 1);
      }
      await ApiAchieviements.addAchieviements(
          (maxTime.inMilliseconds - remainingTime.inMilliseconds).toDouble() /
              1000,
          (points * 100).toInt(),
          levelNow,
          1,
          //widget.account.id,
          //widget.account.accessToken!,
          _game.cardCount ~/ 2);
    }
    if (mounted)
      setState(() {
        continueVisible = true;
      });
  }

  late Future _initResource;
  Future<void> initResource() async {
    levelNow = widget.level;
    await _game.initGame(levelNow, widget.contestId, widget.topicId);
    if (widget.contestId != null) {
      _game.gameImg = await _game.initGameImg(0);
    } else if (widget.roomCode != null) {
      numberPlayer =
          (await ApiRoom.getRoomLeaderboard(widget.roomCode!)).length;
    } else {
      _game.gameImg = await _game.initGameImg(levelNow);
    }
    cardKeys = List<GlobalKey<FlipCardState>>.generate(
      _game.gameImg.length,
      (index) => GlobalKey<FlipCardState>(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    au.dispose();
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
    if (widget.roomCode != null) {
      _databaseReference
          .child('room')
          .child(widget.roomCode!)
          .child('AmountPlayerDone')
          .onValue
          .listen((event) {
        if (isNotaddAccountInRoom && event.snapshot.exists) {
          isNotaddAccountInRoom = false;
          _databaseReference
              .child('room')
              .child(widget.roomCode!)
              .child('AmountPlayerDone')
              .set(int.parse(event.snapshot.value.toString()) + 1);
        }
      });
    }
  }

  void _continue() async {
    double points = (remainingTime.inMilliseconds / 1000);
    if (isLosed == false) {
      if (widget.contestId != null) {
        await ContestsAPI.addAccountInContest(
            (maxTime.inMilliseconds - remainingTime.inMilliseconds).toDouble() /
                1000,
            (points * 100).toInt(),
            widget.contestId!);
        Account? account = await SharedPreferencesHelper.getInfo();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FinalResultScreen(
                  points: (points * 100).toInt(),
                  status: 'win',
                  gameId: 1,
                  totalCoin:
                      account!.coin! + ((points * 100).toInt() / 10).toInt(),
                  contestId: widget.contestId!)),
          (route) => false,
        );
      } else if (widget.roomCode != null) {
        await ApiRoom.addAccountInRoom(
            widget.roomCode!, (points * 100).toInt());
        DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
        _databaseReference
            .child('room')
            .child(widget.roomCode!)
            .child('AmountPlayerDone')
            .onValue
            .listen((event) {
          if (isNotaddAccountInRoom && event.snapshot.exists) {
            isNotaddAccountInRoom = false;
            _databaseReference
                .child('room')
                .child(widget.roomCode!)
                .child('AmountPlayerDone')
                .set(int.parse(event.snapshot.value.toString()) + 1);
          }
          if (int.parse(event.snapshot.value.toString()) >= numberPlayer) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LeaderBoardScreen(gameId: 0, roomCode: widget.roomCode),
              ),
              (route) => false,
            );
          }
        });
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WinScreen(
              haveTime: true,
              points: (points * 100).toInt(),
              time: (maxTime.inMilliseconds - remainingTime.inMilliseconds)
                      .toDouble() /
                  1000,
              isWin: true,
              gameName: widget.gameName,
              gameId: 1,
              contestId: widget.contestId,
            ),
          ),
          (route) => false,
        );
      }
    } else {
      if (widget.contestId != null) {
        await ContestsAPI.addAccountInContest(
            (maxTime.inMilliseconds - remainingTime.inMilliseconds).toDouble() /
                1000,
            0,
            widget.contestId!);
        Account? account = await SharedPreferencesHelper.getInfo();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FinalResultScreen(
                  points: 0,
                  status: 'lose',
                  gameId: 1,
                  totalCoin: account!.coin!,
                  contestId: widget.contestId!)),
          (route) => false,
        );
      } else if (widget.roomCode != null) {
        //await ApiRoom.addAccountInRoom(widget.roomCode!, 0);
        DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
        _databaseReference
            .child('room')
            .child(widget.roomCode!)
            .child('AmountPlayerDone')
            .onValue
            .listen((event) {
          if (isNotaddAccountInRoom && event.snapshot.exists) {
            isNotaddAccountInRoom = false;
            _databaseReference
                .child('room')
                .child(widget.roomCode!)
                .child('AmountPlayerDone')
                .set(int.parse(event.snapshot.value.toString()) + 1);
          }
          if (int.parse(event.snapshot.value.toString()) >= numberPlayer) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LeaderBoardScreen(gameId: 0, roomCode: widget.roomCode),
              ),
              (route) => false,
            );
          }
        });
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WinScreen(
              haveTime: false,
              points: 0,
              time: 0,
              isWin: false,
              gameName: widget.gameName,
              gameId: 1,
              contestId: widget.contestId,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    au.setSourceAsset('sound/back1.mp3').then((value) {
      au.setPlayerMode(PlayerMode.mediaPlayer);
      au.play(AssetSource('sound/back1.mp3'));
    });

    au.onPlayerComplete.listen((event) {
      au.play(AssetSource('sound/back1.mp3'));
    });
    _game = FlipCardGame();
    _initResource = initResource();

    _initResource.then((value) => {
          if (mounted)
            setState(() {
              maxTime = Duration(seconds: _game.time.round());
              remainingTime = maxTime;
              total = (_game.cardCount ~/ 2).toInt();
              pair = (count ~/ 2).toInt();
              percent = pair / total;
              _isLoading = false;
            })
        });
  }

  void pause() {
    timer?.cancel();

    setState(() {
      if (_timerStarted) {
        _timerStarted = false;
      }
    });
  }

  void resume() {
    if (!_timerStarted) {
      startTimer();
      _timerStarted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: continueVisible == false
          ? const Color.fromARGB(255, 255, 240, 199)
          : Color.fromRGBO(234, 67, 53, 1),
      extendBodyBehindAppBar: false,
      appBar: TGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.26,
        //userAvatar: widget.account.avatar!,
        userAvatar: widget.account.avatar!,
        remainingTime: remainingTime,
        gameName: widget.gameName,
        percent: percent,
        progressTitle: "Flipped",
        progressMessage: "$pair/$total",
        onPause: pause,
        onResume: resume,
      ),
      body: Visibility(
        visible: !_isLoading,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.74,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 255, 240, 199),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.74,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                    child: GridView.builder(
                      itemCount: _game.gameImg.length,
                      gridDelegate: _game.cardCount == 6
                          ? const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            )
                          : const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                      itemBuilder: (context, index) {
                        bool isMatched = _game.matchedCards[index];

                        return FlipCard(
                          key: cardKeys[index],
                          // flipOnTouch: !isMatched &&
                          //     !_isCheckingCards &&
                          //     !isLosed &&
                          //     index != indexCheck &&
                          //     _isFree,
                          flipOnTouch: false,
                          // onFlip: () async {
                          //   if (!isMatched &&
                          //       !_isCheckingCards &&
                          //       !isLosed &&
                          //       index != indexCheck &&
                          //       _isFree) {
                          //     await _handleCardFlip(index, cardKeys[index]);
                          //   }
                          // },
                          front: InkWell(
                            onTap: () async {
                              if (!isMatched &&
                                  !_isCheckingCards &&
                                  !isLosed &&
                                  index != indexCheck &&
                                  _isFree) {
                                await _handleCardFlip(index, cardKeys[index]);
                              }
                            },
                            child: Card(
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/pics/logo_2.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          back: Card(
                            child: Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(_game.gameImg[index])),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: continueVisible,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  color: const Color.fromARGB(85, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 76,
                      width: 336,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 132, 53, 13),
                              blurRadius: 0,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _continue,
                          style: button1v1,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _handleCardFlip(int index, GlobalKey<FlipCardState> cardKey) async {
    setState(() {
      _isFree = false;
    });
    if (!_timerStarted) {
      startTimer();
      _timerStarted = true;
    }

    if (_game.matchedCards[index] || _isCheckingCards) {
      return;
    }
    AudioPlayer au = AudioPlayer();
    au.setSourceAsset('sound/flip.mp3').then((value) {
      au.setPlayerMode(PlayerMode.mediaPlayer);
      au.play(AssetSource('sound/flip.mp3'));
    });

    au.onPlayerComplete.listen((event) {
      au.dispose();
    });

    await cardKey.currentState!.toggleCard();

    // if (checkCardKeys.isNotEmpty && checkCardKeys.contains(cardKey)) {
    //   return;
    // }
    //_areAllCardsFlipped();

    if (mounted)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        indexCheck = index;
        _game.gameImg[index] = _game.duplicatedCardList![index];
        _game.matchCheck.add({index: _game.duplicatedCardList![index]});
        checkCardKeys.add(cardKey);
        //print(checkCardKeys[index].currentState);
        print(_game.matchCheck);
        print(checkCardKeys);
      });

    if (_game.matchCheck.length == 2) {
      if (mounted)
        // ignore: curly_braces_in_flow_control_structures
        setState(() {
          _isCheckingCards = true;
          indexCheck = -1;
        });

      //double points = (remainingTime.inMilliseconds / 1000);
      if (_game.matchCheck[0].values.first ==
              _game.matchCheck[1].values.first &&
          _game.matchCheck[0].keys.first != _game.matchCheck[1].keys.first) {
        int firstCardIndex = _game.matchCheck[0].keys.first;
        int secondCardIndex = _game.matchCheck[1].keys.first;
        _game.matchedCards[firstCardIndex] = true;
        _game.matchedCards[secondCardIndex] = true;
        print(_game.matchedCards);
        if (mounted)
          // ignore: curly_braces_in_flow_control_structures
          setState(() {
            count += 2;
            _isCheckingCards = false;
            total = (_game.cardCount ~/ 2).toInt();
            pair = (count ~/ 2).toInt();
            percent = pair / total;
          });

        checkCardKeys.clear();
        _game.matchCheck.clear();
      } else {
        await Future.delayed(Duration(milliseconds: 700), () async {
          if (mounted) {
            print(checkCardKeys[0].currentState?.isFront.toString());
            print(checkCardKeys[1].currentState?.isFront.toString());

            while (checkCardKeys.length == 2 &&
                (checkCardKeys[0].currentState!.isFront &&
                    checkCardKeys[1].currentState!.isFront)) {
              await Future.delayed(Duration(milliseconds: 100));
            }

            await checkCardKeys[0].currentState?.toggleCard();
            await checkCardKeys[1].currentState?.toggleCard();
            setState(() {
              setState(() {
                _isFree = true;
              });
              _isCheckingCards = false;
            });
          }
          // ignore: curly_braces_in_flow_control_structures

          checkCardKeys.clear();
          _game.matchCheck.clear();
          print(_game.matchedCards);
        });
        print("lat lai");
      }
    }

    // if (_areAllCardsFlipped()) {
    //   timer?.cancel();
    // }
    if (count >= _game.cardCount) {
      timer?.cancel();
      win();
    }

    setState(() {
      _isFree = true;
    });

    print(indexCheck);
  }
}
