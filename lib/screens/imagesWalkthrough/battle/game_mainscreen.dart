import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/api/battle_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/imageswalkthrough.dart';
import 'package:thinktank_mobile/models/imageswalkthrough_game.dart';
import 'package:thinktank_mobile/screens/contest/finalresult_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/battle/imageswalkthroughgame_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/endgame_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/startgame_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/battle_game_appbar.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class GameBattleMainScreen extends StatefulWidget {
  const GameBattleMainScreen({
    super.key,
    //required this.account,
    //required this.competitor,
    required this.gameName,
    required this.levelNumber,
    this.contestId,
    required this.roomId,
    required this.account,
    required this.opponentName,
    required this.opponentAvt,
    required this.isUSer1,
    required this.opponentId,
    this.isWithFriend,
  });

  //final Account account;
  //final Account competitor;
  final String gameName;
  final int levelNumber;
  final int? contestId;
  final String roomId;
  final Account account;
  final String opponentName;
  final String opponentAvt;
  final int opponentId;
  final bool isUSer1;
  final bool? isWithFriend;

  @override
  State<GameBattleMainScreen> createState() => _GameBattleMainScreenState();
}

class _GameBattleMainScreenState extends State<GameBattleMainScreen> {
  String selectedAnswer = "";
  //bool isOutTime = false;
  var activeScreen = 'start-screen';
  Timer? timer;
  bool _timerStarted = false;
  double percent = 0.0;
  bool isCompleted = false;
  final progressTitle = "Correct";
  int total = 0;
  List<String> selectedAnswers = [];
  List<String> matchCheck = [];
  int correct = 0;
  int correctOpponent = 0;
  DateTime startTime = DateTime.now();
  List<ImagesWalkthrough> gameSource = [];
  Duration remainingTime = Duration(
    seconds: 0,
  );
  Duration maxTime = Duration(
    seconds: 0,
  );

  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<StreamSubscription<DatabaseEvent>> listEvent = [];
  bool continueVisible = false;
  bool isLosed = false;
  late ImagesWalkthroughGame _game;
  bool chatVisible = false;
  bool isICon = false;
  String opponentName = '';
  String messgae = '';
  String progressOpponentId = '';
  String progressUserId = '';
  List<MessageChat> listMessage = [];
  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        final newTime = remainingTime - const Duration(milliseconds: 500);
        if (newTime.isNegative) {
          timer!.cancel();
          setState(() {
            isLosed = true;
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
    print("level ${widget.levelNumber}");
    await _game.initGame(widget.levelNumber, widget.contestId, null);
  }

  void reported(int index) {
    MessageChat msTmp = listMessage[index];
    MessageChat ms = MessageChat(
      isOwner: msTmp.isOwner,
      content: msTmp.content,
      name: msTmp.name,
      idOpponent: msTmp.idOpponent,
      isReported: true,
      index: index,
    );
    setState(() {
      listMessage[index] = ms;
    });
  }

  @override
  void initState() {
    super.initState();
    _game = ImagesWalkthroughGame();
    _initResource = initResource();
    _databaseReference
        .child('battle')
        .child(widget.roomId)
        .child('chat')
        .onChildAdded
        .listen((event) async {
      print(event.snapshot.value.toString());
      if (event.snapshot.value
                  .toString()
                  .substring(0, widget.opponentName.length) ==
              widget.opponentName &&
          mounted) {
        int index = listMessage.length;
        listMessage.add(MessageChat(
          isOwner: false,
          content: event.snapshot.value
              .toString()
              .substring(widget.opponentName.length + 3),
          name: widget.opponentName,
          idOpponent: widget.opponentId,
          isReported: false,
          reported: reported,
          index: index,
        ));
        setState(() {
          chatVisible = true;
          listMessage;
          messgae = event.snapshot.value
              .toString()
              .substring(widget.opponentName.length + 3);
        });
        await Future.delayed(Duration(seconds: 6));
        setState(() {
          chatVisible = false;
        });
      } else {
        int index = listMessage.length;
        listMessage.add(MessageChat(
          isOwner: true,
          content: event.snapshot.value
              .toString()
              .substring(widget.account.userName.length + 3),
          name: widget.account.userName,
          idOpponent: null,
          isReported: false,
          reported: reported,
          index: index,
        ));
        setState(() {
          listMessage;
        });
      }
    });

    _databaseReference
        .child('battle')
        .child(widget.roomId)
        .child('iconChat')
        .onChildAdded
        .listen((event) async {
      print(event.snapshot.value.toString());
      if (event.snapshot.value
                  .toString()
                  .substring(0, widget.opponentName.length) ==
              widget.opponentName &&
          mounted) {
        setState(() {
          chatVisible = true;
          isICon = true;
          messgae = event.snapshot.value
              .toString()
              .substring(widget.opponentName.length + 3);
        });
        await Future.delayed(Duration(seconds: 6));
        setState(() {
          chatVisible = false;
          isICon = false;
        });
      }
    });

    if (widget.isUSer1) {
      progressOpponentId = 'progress2';
      progressUserId = 'progress1';
    } else {
      progressOpponentId = 'progress1';
      progressUserId = 'progress2';
    }
    listEvent.add(_databaseReference
        .child('battle')
        .child(widget.roomId)
        .child(progressOpponentId)
        .onValue
        .listen((event) {
      if (mounted) {
        setState(() {
          if (int.parse(event.snapshot.value.toString()) >= 0 && mounted) {
            correctOpponent = int.parse(event.snapshot.value.toString());
          }
        });
      }
    }));
    _initResource.then(
      (value) => {
        setState(
          () {
            continueVisible = false;
            maxTime = Duration(seconds: _game.time.round());
            remainingTime = maxTime;
            gameSource = _game.gameData;
            total = _game.gameData.length - 1;
            correct = selectedAnswer.length;
            percent = correct / total;
            if (!_timerStarted) {
              startTimer();
              _timerStarted = true;
            }
          },
        ),
      },
    );
  }

  void win() async {
    _showResizableDialog(context);
    double points = (remainingTime.inMilliseconds / 1000);
    if (widget.isUSer1) {
      _databaseReference
          .child('battle')
          .child(widget.roomId)
          .child('time1')
          .set(remainingTime.inMilliseconds);
    } else {
      _databaseReference
          .child('battle')
          .child(widget.roomId)
          .child('time2')
          .set(remainingTime.inMilliseconds);
    }
    listEvent.add(_databaseReference
        .child('battle')
        .child(widget.roomId)
        .child(progressOpponentId)
        .onValue
        .listen((event) async {
      if (int.parse(event.snapshot.value.toString()) == -1 && mounted) {
        print('Thắng rồi');
        Account? account = await SharedPreferencesHelper.getInfo();

        await SharedPreferencesHelper.saveInfo(account!);
        isCompleted = true;
        await BattleAPI.addResultBattle(
          20,
          account.id,
          widget.isUSer1 ? account.id : widget.opponentId,
          widget.isUSer1 ? widget.opponentId : account.id,
          4,
          widget.roomId,
          startTime,
        );
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FinalResultScreen(
                    points: points.toInt(),
                    status: 'win',
                    gameId: 4,
                    totalCoin: account.coin!,
                    contestId: widget.contestId,
                    isWithFriend: widget.isWithFriend,
                  )),
          (route) => false,
        );
      }
    }));
    if (widget.isUSer1) {
      listEvent.add(_databaseReference
          .child('battle')
          .child(widget.roomId)
          .child('time2')
          .onValue
          .listen((event) async {
        if (event.snapshot.exists && mounted) {
          if (remainingTime.inMilliseconds >
              int.parse(event.snapshot.value.toString())) {
            print('Thắng do còn nhiều time hơn');
            Account? account = await SharedPreferencesHelper.getInfo();

            await SharedPreferencesHelper.saveInfo(account!);
            isCompleted = true;
            await BattleAPI.addResultBattle(
              20,
              account.id,
              widget.isUSer1 ? account.id : widget.opponentId,
              widget.isUSer1 ? widget.opponentId : account.id,
              4,
              widget.roomId,
              startTime,
            );
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalResultScreen(
                        points: points.toInt(),
                        status: 'win',
                        gameId: 4,
                        totalCoin: account.coin!,
                        contestId: widget.contestId,
                        isWithFriend: widget.isWithFriend,
                      )),
              (route) => false,
            );
          } else if (remainingTime.inMilliseconds <
              int.parse(event.snapshot.value.toString())) {
            print('Thua do ít time hơn');
            Account? account = await SharedPreferencesHelper.getInfo();
            account!.coin = account.coin! - 20;
            await SharedPreferencesHelper.saveInfo(account);
            isCompleted = true;
            await BattleAPI.addResultBattle(
              20,
              widget.opponentId,
              widget.isUSer1 ? account.id : widget.opponentId,
              widget.isUSer1 ? widget.opponentId : account.id,
              4,
              widget.roomId,
              startTime,
            );
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalResultScreen(
                        points: points.toInt(),
                        status: 'lose',
                        gameId: 4,
                        totalCoin: account.coin!,
                        contestId: widget.contestId,
                        isWithFriend: widget.isWithFriend,
                      )),
              (route) => false,
            );
          } else {
            print('Hòa');
            Account? account = await SharedPreferencesHelper.getInfo();
            isCompleted = true;
            await BattleAPI.addResultBattle(
              20,
              0,
              widget.isUSer1 ? account!.id : widget.opponentId,
              widget.isUSer1 ? widget.opponentId : account!.id,
              4,
              widget.roomId,
              startTime,
            );
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalResultScreen(
                        points: points.toInt(),
                        status: 'draw',
                        gameId: 4,
                        totalCoin: account!.coin!,
                        contestId: widget.contestId,
                        isWithFriend: widget.isWithFriend,
                      )),
              (route) => false,
            );
          }
        }
      }));
    } else {
      listEvent.add(_databaseReference
          .child('battle')
          .child(widget.roomId)
          .child('time1')
          .onValue
          .listen((event) async {
        if (event.snapshot.exists && mounted) {
          if (remainingTime.inMilliseconds >
              int.parse(event.snapshot.value.toString())) {
            print('Thắng do còn nhiều time hơn');
            Account? account = await SharedPreferencesHelper.getInfo();

            await SharedPreferencesHelper.saveInfo(account!);
            isCompleted = true;
            await BattleAPI.addResultBattle(
              20,
              account.id,
              widget.isUSer1 ? account.id : widget.opponentId,
              widget.isUSer1 ? widget.opponentId : account.id,
              4,
              widget.roomId,
              startTime,
            );
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalResultScreen(
                        points: points.toInt(),
                        status: 'win',
                        gameId: 4,
                        totalCoin: account.coin!,
                        contestId: widget.contestId,
                        isWithFriend: widget.isWithFriend,
                      )),
              (route) => false,
            );
          } else if (remainingTime.inMilliseconds <
              int.parse(event.snapshot.value.toString())) {
            print('Thua do ít time hơn');
            Account? account = await SharedPreferencesHelper.getInfo();
            account!.coin = account.coin! - 20;
            await SharedPreferencesHelper.saveInfo(account);
            isCompleted = true;
            await BattleAPI.addResultBattle(
              20,
              widget.opponentId,
              widget.isUSer1 ? account.id : widget.opponentId,
              widget.isUSer1 ? widget.opponentId : account.id,
              4,
              widget.roomId,
              startTime,
            );
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalResultScreen(
                        points: points.toInt(),
                        status: 'lose',
                        gameId: 4,
                        totalCoin: account.coin!,
                        contestId: widget.contestId,
                        isWithFriend: widget.isWithFriend,
                      )),
              (route) => false,
            );
          } else {
            print('Hòa');
            Account? account = await SharedPreferencesHelper.getInfo();
            isCompleted = true;
            await BattleAPI.addResultBattle(
              20,
              0,
              widget.isUSer1 ? account!.id : widget.opponentId,
              widget.isUSer1 ? widget.opponentId : account!.id,
              4,
              widget.roomId,
              startTime,
            );
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalResultScreen(
                        points: points.toInt(),
                        status: 'draw',
                        gameId: 4,
                        totalCoin: account!.coin!,
                        contestId: widget.contestId,
                        isWithFriend: widget.isWithFriend,
                      )),
              (route) => false,
            );
          }
        }
      }));
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
    setState(() {
      correct = 0;
      continueVisible = true;
      _databaseReference
          .child('battle')
          .child(widget.roomId)
          .child(progressUserId)
          .set(correct);
      percent = correct / total;
      activeScreen = 'start-screen';
    });
  }

  void onTimeIsEnd() async {
    timer?.cancel();
    setState(() {
      correct = 0;
      _databaseReference
          .child('battle')
          .child(widget.roomId)
          .child(progressUserId)
          .set(correct);
      percent = correct / total;
      activeScreen = 'end-screen';
      if (_timerStarted) {
        _timerStarted = false;
      }
    });
    _databaseReference
        .child('battle')
        .child(widget.roomId)
        .child(progressUserId)
        .set(-1);
    listEvent.add(_databaseReference
        .child('battle')
        .child(widget.roomId)
        .child(progressOpponentId)
        .onValue
        .listen((event) async {
      if (int.parse(event.snapshot.value.toString()) == -1 && mounted) {
        print('Hòa - Cả 2 đều không hoàn thành');
        Account? account = await SharedPreferencesHelper.getInfo();
        isCompleted = true;
        await BattleAPI.addResultBattle(
          20,
          0,
          widget.isUSer1 ? account!.id : widget.opponentId,
          widget.isUSer1 ? widget.opponentId : account!.id,
          4,
          widget.roomId,
          startTime,
        );
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FinalResultScreen(
                    points: 0,
                    status: 'draw',
                    gameId: 4,
                    totalCoin: account!.coin!,
                    contestId: widget.contestId,
                    isWithFriend: widget.isWithFriend,
                  )),
          (route) => false,
        );
      }
    }));
    if (widget.isUSer1) {
      listEvent.add(_databaseReference
          .child('battle')
          .child(widget.roomId)
          .child('time2')
          .onValue
          .listen((event) async {
        if (event.snapshot.exists && mounted) {
          print('Thua rồi');
          Account? account = await SharedPreferencesHelper.getInfo();
          account!.coin = account.coin! - 20;
          await SharedPreferencesHelper.saveInfo(account);
          isCompleted = true;
          await BattleAPI.addResultBattle(
            20,
            widget.opponentId,
            widget.isUSer1 ? account.id : widget.opponentId,
            widget.isUSer1 ? widget.opponentId : account.id,
            4,
            widget.roomId,
            startTime,
          );
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => FinalResultScreen(
                      points: 0,
                      status: 'lose',
                      gameId: 4,
                      totalCoin: 0,
                      contestId: widget.contestId,
                      isWithFriend: widget.isWithFriend,
                    )),
            (route) => false,
          );
        }
      }));
    } else {
      listEvent.add(_databaseReference
          .child('battle')
          .child(widget.roomId)
          .child('time1')
          .onValue
          .listen((event) async {
        if (event.snapshot.exists && mounted) {
          print('Thua rồi');
          Account? account = await SharedPreferencesHelper.getInfo();
          account!.coin = account.coin! - 20;
          await SharedPreferencesHelper.saveInfo(account);
          isCompleted = true;
          await BattleAPI.addResultBattle(
            20,
            widget.opponentId,
            widget.isUSer1 ? account.id : widget.opponentId,
            widget.isUSer1 ? widget.opponentId : account.id,
            4,
            widget.roomId,
            startTime,
          );
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => FinalResultScreen(
                      points: 0,
                      status: 'lose',
                      gameId: 4,
                      totalCoin: 0,
                      contestId: widget.contestId,
                      isWithFriend: widget.isWithFriend,
                    )),
            (route) => false,
          );
        }
      }));
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!isCompleted) {
      _databaseReference
          .child('battle')
          .child(widget.roomId)
          .child(progressUserId)
          .set(-1);
    }
    for (var element in listEvent) {
      element.cancel();
    }
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
      screenWidget = ImagesWalkthroughBattleGameScreen(
        onSelectImage: (imgAnswer) {
          chooseAnswer(imgAnswer);
        },
        onCorrectAnswer: () {
          setState(() {
            correct++;
            _databaseReference
                .child('battle')
                .child(widget.roomId)
                .child(progressUserId)
                .set(correct);
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
        onEndTime: () {},
        onDone: () {},
      );
    }

    if (activeScreen == 'end-screen') {
      screenWidget = EndGameScreen(
        onContinue: () {},
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color.fromARGB(255, 255, 240, 199),
      appBar: TBattleGameAppBar(
        percentOpponent: correctOpponent / total,
        progressMessageOpponent: "$correctOpponent/$total",
        progressTitleOpponent: widget.opponentName,
        preferredHeight: MediaQuery.of(context).size.height * 0.35,
        listMessage: listMessage,
        chatVisible: chatVisible,
        messgae: messgae,
        userName: widget.account.userName,
        roomId: widget.roomId,
        userAvatar: widget.opponentAvt,
        competitorAvatar: widget.account.avatar ??
            "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
        remainingTime: remainingTime,
        gameName: "Images Walkthrough",
        progressTitle: widget.account.userName,
        progressMessage: "$correct/$total",
        percent: percent,
        onPause: () {},
        onResume: () {},
        isIcon: isICon,
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
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/animPics/wait.gif',
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
