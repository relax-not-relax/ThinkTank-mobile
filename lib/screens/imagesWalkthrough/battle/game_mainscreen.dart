import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/imageswalkthrough.dart';
import 'package:thinktank_mobile/models/imageswalkthrough_game.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/battle/startgame_screen.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/startgame_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/battle_game_appbar.dart';

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
  });

  //final Account account;
  //final Account competitor;
  final String gameName;
  final int levelNumber;
  final int? contestId;
  final String roomId;
  final Account account;
  final String opponentName;

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

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  bool continueVisible = false;
  bool isLosed = false;
  late ImagesWalkthroughGame _game;
  bool chatVisible = false;
  String opponentName = '';
  String messgae = '';
  List<MessageChat> listMessage = [];
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
    await _game.initGame(widget.levelNumber, widget.contestId);
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
          widget.opponentName) {
        setState(() {
          chatVisible = true;
          listMessage.add(MessageChat(
              isOwner: false,
              content: event.snapshot.value
                  .toString()
                  .substring(widget.opponentName.length + 3),
              name: widget.opponentName));
          messgae = event.snapshot.value
              .toString()
              .substring(widget.opponentName.length + 3);
        });
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          chatVisible = false;
        });
      } else {
        setState(() {
          listMessage.add(MessageChat(
              isOwner: true,
              content: event.snapshot.value
                  .toString()
                  .substring(widget.account.userName.length + 3),
              name: widget.account.userName));
        });
      }
    });

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
            print(gameSource[0].answerImgPath);
          },
        ),
      },
    );
  }

  void switchScreen() {}

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = StartBattleGameScreen(
        //source: gameSource,
        );

    if (activeScreen == 'start-screen') {
      StartBattleGameScreen(
          //source: gameSource,
          );
    }

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color.fromARGB(255, 255, 240, 199),
      appBar: TBattleGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.35,
        listMessage: listMessage,
        chatVisible: chatVisible,
        messgae: messgae,
        userName: widget.account.userName,
        roomId: widget.roomId,
        userAvatar:
            "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
        competitorAvatar:
            "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
        remainingTime: Duration(
          seconds: 0,
        ),
        gameName: "Images Walkthrough",
        progressTitle: "Image",
        progressMessage: "0/0",
        percent: 0,
        onPause: () {},
        onResume: () {},
      ),
      body: Container(
        child: screenWidget,
      ),
    );
  }
}
