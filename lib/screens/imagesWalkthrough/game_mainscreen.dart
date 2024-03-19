import 'dart:async';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
// import 'package:thinktank_mobile/data/imageswalkthrough_data.dart';
// import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/imageswalkthrough.dart';
import 'package:thinktank_mobile/models/imageswalkthrough_game.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/endgame_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/imageswalkthroughgame_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/startgame_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';
import 'package:thinktank_mobile/widgets/others/winscreen.dart';

class GameMainScreen extends StatefulWidget {
  const GameMainScreen({
    super.key,
    required this.account,
    required this.gameName,
    required this.levelNumber,
  });

  final Account account;
  final String gameName;
  final int levelNumber;

  @override
  State<GameMainScreen> createState() => _GameMainScreenState();
}

class _GameMainScreenState extends State<GameMainScreen> {
  String selectedAnswer = "";
  //bool isOutTime = false;
  var activeScreen = 'start-screen';
  Timer? timer;
  bool _timerStarted = false;
  double percent = 0.0;
  final progressTitle = "Correct";
  int total = 0;
  List<String> selectedAnswers = [];
  List<String> matchCheck = [];
  int correct = 0;
  List<ImagesWalkthrough> gameSource = [];
  Duration remainingTime = Duration(
    seconds: 0,
  );
  Duration maxTime = Duration(
    seconds: 0,
  );
  bool continueVisible = false;
  bool isLosed = false;
  late ImagesWalkthroughGame _game;

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

  late Future _initResource;
  Future<void> initResource() async {
    await _game.initGame(widget.levelNumber);
  }

  @override
  void initState() {
    super.initState();
    _game = ImagesWalkthroughGame();
    _initResource = initResource();

    _initResource.then((value) => {
          setState(
            () {
              maxTime = Duration(seconds: _game.time.round());
              remainingTime = maxTime;
              gameSource = _game.gameData;
              total = _game.gameData.length - 1;
              correct = selectedAnswer.length;
              percent = correct / total;
              print(gameSource[0].answerImgPath);
            },
          ),
        });

    //print(gameSource.toString());

    // setState(() {
    //   remainingTime = const Duration(seconds: 120);
    //   total = walkthroughs.length - 1;
    //   correct = selectedAnswer.length;
    //   percent = correct / total;
    // });
  }

  void win() async {
    double points = (remainingTime.inMilliseconds / 1000);
    await SharedPreferencesHelper.saveImagesWalkthroughLevel(
        widget.levelNumber + 1);
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
            gameId: 4,
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
            gameId: 4,
          ),
        ),
        (route) => false,
      );
    }
  }

  void switchScreen() {
    if (isLosed == false) {
      setState(() {
        activeScreen = 'questions-screen';
        if (!_timerStarted) {
          startTimer();
          _timerStarted = true;
        }
      });
    } else {
      setState(() {
        correct = 0;
        percent = correct / total;
        activeScreen = 'end-screen';
        if (_timerStarted) {
          _timerStarted = false;
        }
      });
    }
  }

  void chooseAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void incorrectSelect() {
    timer?.cancel();

    setState(() {
      correct = 0;
      percent = correct / total;
      activeScreen = 'start-screen';
      if (_timerStarted) {
        _timerStarted = false;
      }
    });
  }

  void onTimeIsEnd() {
    timer?.cancel();

    setState(() {
      correct = 0;
      percent = correct / total;
      activeScreen = 'end-screen';
      if (_timerStarted) {
        _timerStarted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = StartGameScreen(
      startImage: switchScreen,
      source: gameSource,
    );

    //Widget screenWidget = ImagesWalkthroughGameScreen();

    if (activeScreen == 'start-screen') {
      StartGameScreen(
        startImage: switchScreen,
        source: gameSource,
      );
    }

    if (activeScreen == 'questions-screen') {
      screenWidget = ImagesWalkthroughGameScreen(
        onSelectImage: (imgAnswer) {
          chooseAnswer(imgAnswer);
        },
        onCorrectAnswer: () {
          setState(() {
            correct++;
            percent = correct / total;
          });
        },
        onEndGame: () async {
          timer?.cancel();
          setState(() {
            timer = null;
          });
          win();
        },
        onInCorrectAnswer: () {
          incorrectSelect();
        },
        source: gameSource,
        isEnd: isLosed,
        onEndTime: () {
          onTimeIsEnd();
        },
        onDone: _continue,
      );
    }

    if (activeScreen == 'end-screen') {
      screenWidget = EndGameScreen();
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color.fromARGB(255, 255, 240, 199),
      appBar: TGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.26,
        userAvatar:
            "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fava_test.png?alt=media&token=5929a6ce-f92d-4670-8b7e-954fed01abc0",
        remainingTime: remainingTime,
        gameName: "Images Walkthrough",
        progressTitle: "Image",
        progressMessage: "$correct/$total",
        percent: percent,
      ),
      body: Container(
        child: screenWidget,
      ),
    );
  }
}
