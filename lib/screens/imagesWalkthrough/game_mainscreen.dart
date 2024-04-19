import 'dart:async';
// import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/api/room_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
// import 'package:thinktank_mobile/data/imageswalkthrough_data.dart';
// import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/imageswalkthrough.dart';
import 'package:thinktank_mobile/models/imageswalkthrough_game.dart';
import 'package:thinktank_mobile/screens/contest/finalresult_screen.dart';
import 'package:thinktank_mobile/screens/game/leaderboard.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/endgame_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/imageswalkthroughgame_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/startgame_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/winscreen.dart';

class GameMainScreen extends StatefulWidget {
  const GameMainScreen({
    super.key,
    required this.account,
    required this.gameName,
    required this.levelNumber,
    this.contestId,
    this.roomCode,
    this.topicId,
  });

  final Account account;
  final String gameName;
  final int levelNumber;
  final int? contestId;
  final String? roomCode;
  final int? topicId;

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
  bool isNotaddAccountInRoom = true;
  int total = 0;
  List<String> selectedAnswers = [];
  List<String> matchCheck = [];
  int numberPlayer = 0;
  int correct = 0;
  List<ImagesWalkthrough> gameSource = [];
  AudioPlayer au = AudioPlayer();
  Duration remainingTime = Duration(
    seconds: 0,
  );
  Duration maxTime = Duration(
    seconds: 0,
  );
  bool continueVisible = true;
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
          onTimeIsEnd();
        } else {
          remainingTime = newTime;
        }
      });
    });
  }

  late Future _initResource;
  Future<void> initResource() async {
    await _game.initGame(widget.levelNumber, widget.contestId, widget.topicId);
    if (widget.roomCode != null) {
      numberPlayer =
          (await ApiRoom.getRoomLeaderboard(widget.roomCode!)).length;
    }
  }

  @override
  void initState() {
    super.initState();
    au.setSourceAsset('sound/back2.mp3').then((value) {
      au.setPlayerMode(PlayerMode.mediaPlayer);
      au.play(AssetSource('sound/back2.mp3'));
    });

    au.onPlayerComplete.listen((event) {
      au.play(AssetSource('sound/back2.mp3'));
    });
    _game = ImagesWalkthroughGame();
    _initResource = initResource();

    _initResource.then(
      (value) => {
        setState(
          () {
            maxTime = Duration(seconds: _game.time.round());
            remainingTime = maxTime;
            gameSource = _game.gameData;
            total = _game.gameData.length - 1;
            correct = selectedAnswer.length;
            percent = correct / total;
            if (!_timerStarted && widget.roomCode != null) {
              startTimer();
              _timerStarted = true;
            }
          },
        ),
      },
    );
  }

  void win() async {
    double points = (remainingTime.inMilliseconds / 1000);

    if (widget.contestId == null && widget.roomCode == null) {
      int levelMax = await SharedPreferencesHelper.getImagesWalkthroughLevel();
      if (levelMax == widget.levelNumber) {
        await SharedPreferencesHelper.saveImagesWalkthroughLevel(
            widget.levelNumber + 1);
      }

      await ApiAchieviements.addAchieviements(
          (maxTime.inMilliseconds - remainingTime.inMilliseconds).toDouble() /
              1000,
          (points * 100).toInt(),
          widget.levelNumber,
          4,
          _game.gameData.length - 1);
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
                  gameId: 4,
                  totalCoin: account!.coin!,
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
          _showResizableDialog(context);
          if (int.parse(event.snapshot.value.toString()) >= numberPlayer &&
              mounted) {
            Future.delayed(Duration(seconds: 5));
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
              gameId: 4,
              contestId: widget.contestId,
            ),
          ),
          (route) => false,
        );
      }
    }
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

  void _continueLosed() async {
    if (isLosed == true) {
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
                  gameId: 4,
                  totalCoin: account!.coin!,
                  contestId: widget.contestId!)),
          (route) => false,
        );
      } else if (widget.roomCode != null) {
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
          _showResizableDialog(context);
          if (int.parse(event.snapshot.value.toString()) >= numberPlayer &&
              mounted) {
            Future.delayed(Duration(seconds: 5));
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
              gameId: 4,
              contestId: widget.contestId,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  void switchScreen() async {
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
      await Future.delayed(Duration(seconds: 3));
      _continueLosed();
    }
  }

  void chooseAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void incorrectSelect() {
    if (widget.roomCode != null) {
      timer?.cancel();
    }

    setState(() {
      correct = 0;
      percent = correct / total;
      activeScreen = 'start-screen';
      if (_timerStarted && widget.roomCode != null) {
        _timerStarted = false;
      }
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

  void onTimeIsEnd() async {
    timer?.cancel();

    setState(() {
      correct = 0;
      percent = correct / total;
      activeScreen = 'end-screen';
      if (_timerStarted) {
        _timerStarted = false;
      }
    });
    await Future.delayed(Duration(seconds: 3));
    _continueLosed();
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    Widget screenWidget = StartGameScreen(
      startImage: switchScreen,
      source: gameSource,
      visibleContinue: true,
    );

    //Widget screenWidget = ImagesWalkthroughGameScreen();

    if (activeScreen == 'start-screen') {
      StartGameScreen(
        startImage: switchScreen,
        source: gameSource,
        visibleContinue: true,
      );
    }

    if (activeScreen == 'questions-screen') {
      screenWidget = ImagesWalkthroughGameScreen(
        onSelectImage: (imgAnswer) {
          chooseAnswer(imgAnswer);
        },
        onCorrectAnswer: () {
          AudioPlayer au = AudioPlayer();
          au.setPlayerMode(PlayerMode.mediaPlayer);
          au.play(AssetSource('sound/correct.mp3'));
          au.onPlayerComplete.listen((event) {
            au.dispose();
          });
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
          await Future.delayed(Duration(seconds: 3));
          _continue();
        },
        onInCorrectAnswer: () {
          AudioPlayer au = AudioPlayer();
          au.setPlayerMode(PlayerMode.mediaPlayer);
          au.play(AssetSource('sound/incorrect.mp3'));
          au.onPlayerComplete.listen((event) {
            au.dispose();
          });
          incorrectSelect();
        },
        source: gameSource,
        isEnd: isLosed,
        onEndTime: () {
          onTimeIsEnd();
        },
        onDone: () {},
      );
    }

    if (activeScreen == 'end-screen') {
      screenWidget = EndGameScreen(
        onContinue: _continueLosed,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color.fromARGB(255, 255, 240, 199),
      appBar: TGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.26,
        userAvatar: widget.account.avatar!,
        remainingTime: remainingTime,
        gameName: "Images Walkthrough",
        progressTitle: "Image",
        progressMessage: "$correct/$total",
        percent: percent,
        onPause: pause,
        onResume: resume,
      ),
      body: Container(
        child: screenWidget,
      ),
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
                'Wait for your opponents',
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
                  'Wait for your opponent to complete the game!',
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
