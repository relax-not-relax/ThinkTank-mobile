import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thinktank_mobile/data/imageswalkthrough_data.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/imageswalkthroughgame_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/startgame_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';

class GameMainScreen extends StatefulWidget {
  const GameMainScreen({
    super.key,
    // required this.maxTime,
    // required this.account,
    // required this.gameName,
  });

  // final Duration maxTime;
  // final Account account;
  // final String gameName;

  @override
  State<GameMainScreen> createState() => _GameMainScreenState();
}

class _GameMainScreenState extends State<GameMainScreen> {
  String selectedAnswer = "";
  var activeScreen = 'start-screen';
  Timer? timer;
  late Duration remainingTime;
  bool _timerStarted = false;
  double percent = 0.0;
  final progressTitle = "Flipped";
  int total = 0;
  List<String> selectedAnswers = [];
  List<String> matchCheck = [];
  int correct = 0;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        final newTime = remainingTime - const Duration(milliseconds: 500);
        if (newTime.isNegative) {
          timer!.cancel();
          // setState(() {
          //   isLosed = true;
          //   continueVisible = true;
          // });
        } else {
          remainingTime = newTime;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      remainingTime = const Duration(seconds: 120);
      total = walkthroughs.length - 1;
      correct = selectedAnswer.length;
      percent = correct / total;
    });
  }

  void switchScreen() {
    setState(() {
      activeScreen = 'questions-screen';
      if (!_timerStarted) {
        startTimer();
        _timerStarted = true;
      }
    });
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

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = StartGameScreen(startImage: switchScreen);

    //Widget screenWidget = ImagesWalkthroughGameScreen();

    if (activeScreen == 'start-screen') {
      StartGameScreen(startImage: switchScreen);
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
        onEndGame: () {
          timer?.cancel();
          setState(() {
            timer = null;
          });
        },
        onInCorrectAnswer: () {
          incorrectSelect();
        },
      );
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
