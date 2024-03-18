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
  bool continueVisible = false;
  bool isLosed = false;
  bool _isCheckingCards = false;
  bool _isLoading = true;

  bool _areAllCardsFlipped() {
    print(_game.matchedCards.every((isFlipped) => false));
    return _game.matchedCards.every((isFlipped) => false);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        final newTime = remainingTime - const Duration(milliseconds: 500);
        if (newTime.isNegative) {
          timer!.cancel();
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
    await SharedPreferencesHelper.saveFLipCardLevel(widget.level + 1);
    await ApiAchieviements.addAchieviements(
      (maxTime.inMilliseconds - remainingTime.inMilliseconds).toDouble() / 1000,
      (points * 100).toInt(),
      levelNow,
      1,
      widget.account.id,
      widget.account.accessToken!,
    );
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

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    total = (_game.cardCount ~/ 2).toInt();
    pair = (count ~/ 2).toInt();
    percent = pair / total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 240, 199),
      extendBodyBehindAppBar: false,
      appBar: TGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.26,
        userAvatar: widget.account.avatar!,
        remainingTime: remainingTime,
        gameName: widget.gameName,
        percent: percent,
        progressTitle: "Flipped",
        progressMessage: "$pair/$total",
      ),
      body: Visibility(
        visible: !_isLoading,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 255, 240, 199),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.54,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                child: GridView.builder(
                  itemCount: _game.gameImg.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    bool isMatched = _game.matchedCards[index];

                    return FlipCard(
                      key: cardKeys[index],
                      flipOnTouch: !isMatched && !_isCheckingCards && !isLosed,
                      onFlip: () {
                        if (!isMatched && !_isCheckingCards && !isLosed) {
                          _handleCardFlip(index, cardKeys[index]);
                        }
                      },
                      front: Card(
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
              Visibility(
                visible: continueVisible,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    bottom: 30.0,
                  ),
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

  void _handleCardFlip(int index, GlobalKey<FlipCardState> cardKey) {
    if (!_timerStarted) {
      startTimer();
      _timerStarted = true;
    }
    if (_game.matchedCards[index] || _isCheckingCards) {
      return;
    }
    _areAllCardsFlipped();

    setState(() {
      _game.gameImg[index] = _game.duplicatedCardList![index];
      _game.matchCheck.add({index: _game.duplicatedCardList![index]});
      checkCardKeys.add(cardKey);
    });

    if (_game.matchCheck.length == 2) {
      setState(() {
        _isCheckingCards = true;
      });

      double points = (remainingTime.inMilliseconds / 1000);
      if (_game.matchCheck[0].values.first ==
              _game.matchCheck[1].values.first &&
          _game.matchCheck[0].keys.first != _game.matchCheck[1].keys.first) {
        int firstCardIndex = _game.matchCheck[0].keys.first;
        int secondCardIndex = _game.matchCheck[1].keys.first;
        _game.matchedCards[firstCardIndex] = true;
        _game.matchedCards[secondCardIndex] = true;
        setState(() {
          count += 2;
          _isCheckingCards = false;
        });

        checkCardKeys.clear();
        _game.matchCheck.clear();
      } else {
        Future.delayed(Duration(milliseconds: 600), () {
          setState(() {
            checkCardKeys[0].currentState?.toggleCard();
            checkCardKeys[1].currentState?.toggleCard();
            _isCheckingCards = false;
          });
          checkCardKeys.clear();
          _game.matchCheck.clear();
        });
      }
    }

    // if (_areAllCardsFlipped()) {
    //   timer?.cancel();
    // }
    if (count >= _game.cardCount) {
      timer?.cancel();
      win();
    }
  }
}
