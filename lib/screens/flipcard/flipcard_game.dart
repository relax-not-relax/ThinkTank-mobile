import 'dart:async';
import 'dart:io';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/flipcard.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:thinktank_mobile/widgets/others/winscreen.dart';

class FlipCardGamePlay extends StatefulWidget {
  const FlipCardGamePlay({
    super.key,
    required this.account,
    required this.gameName,
    required this.level,
  });

  final Account account;
  final String gameName;
  final int level;

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
  final progressTitle = "Flipped";
  int total = 0;
  int pair = 0;
  int indexCheck = -1;
  bool continueVisible = false;
  bool isLosed = false;
  bool _isCheckingCards = false;
  bool _isLoading = true;
  bool _isFree = true;

  bool _areAllCardsFlipped() {
    print(_game.matchedCards.every((isFlipped) => false));
    return _game.matchedCards.every((isFlipped) => false);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted)
        setState(() {
          final newTime = remainingTime - const Duration(milliseconds: 500);
          if (newTime.isNegative) {
            timer!.cancel();
            if (mounted)
              setState(() {
                isLosed = true;
                continueVisible = true;
              });
          } else {
            remainingTime = newTime;
          }
        });
    });
  }

  void win() async {
    double points = (remainingTime.inMilliseconds / 1000);
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
        widget.account.id,
        widget.account.accessToken!,
        _game.cardCount ~/ 2);
    if (mounted)
      setState(() {
        continueVisible = true;
      });
  }

  late Future _initResource;
  Future<void> initResource() async {
    levelNow = widget.level;
    await _game.initGame(levelNow);
    _game.gameImg = await _game.initGameImg(levelNow);
    cardKeys = List<GlobalKey<FlipCardState>>.generate(
      _game.gameImg.length,
      (index) => GlobalKey<FlipCardState>(),
    );
    print(_game.gameImg.length.toString() + "abc");

    print(cardKeys);
  }

  void _continue() {
    double points = (remainingTime.inMilliseconds / 1000);
    if (isLosed == false) {
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
          ),
        ),
        (route) => false,
      );
    } else {
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
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
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
        userAvatar: widget.account.avatar!,
        // userAvatar:
        //     "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
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
    await Future.delayed(Duration(milliseconds: 100), () async {
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
    });

    await Future.delayed(Duration.zero, () async {
      if (_game.matchCheck.length == 2) {
        await Future.delayed(Duration.zero, () async {
          if (mounted)
            // ignore: curly_braces_in_flow_control_structures
            setState(() {
              _isCheckingCards = true;
              indexCheck = -1;
            });
        });
        await Future.delayed(Duration.zero, () async {
          if (_game.matchCheck[0].values.first ==
                  _game.matchCheck[1].values.first &&
              _game.matchCheck[0].keys.first !=
                  _game.matchCheck[1].keys.first) {
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
            await Future.delayed(Duration(milliseconds: 600), () async {
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
                  //  _isFree = true;
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
        });
        //double points =remainingTime.inMilliseconds / 1000);
      }
    });

    // if (_areAllCardsFlipped()) {
    //   timer?.cancel();
    // }

    await Future.delayed(Duration.zero, () async {
      if (count >= _game.cardCount) {
        timer?.cancel();
        //win();
      }

      setState(() {
        _isFree = true;
      });

      print(indexCheck);
    });
  }
}
