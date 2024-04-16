import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:provider/provider.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';
import 'package:thinktank_mobile/screens/contest/finalresult_screen.dart';
import 'package:thinktank_mobile/screens/findanonymous/cardprovider.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:thinktank_mobile/widgets/others/textstroke.dart';
import 'package:thinktank_mobile/widgets/others/winscreen.dart';

class AnonymousCard extends StatefulWidget {
  const AnonymousCard(
      {super.key, required this.avtlink, required this.isFront});
  final String avtlink;
  final bool isFront;
  @override
  State<AnonymousCard> createState() => _AnonymousCardState();
}

class _AnonymousCardState extends State<AnonymousCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.isFront ? buildFrontCard() : buildCard();

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final miliseconds = provider.isDragging ? 0 : 300;
          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            duration: Duration(milliseconds: miliseconds),
            curve: Curves.easeInOut,
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: Center(
              child: Stack(
                children: [
                  buildCard(),
                  Container(width: 300, child: buildStamps()),
                ],
              ),
            ),
          );
        }),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
      );

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    switch (status) {
      case CardStatus.confirm:
        final child = buildStamp(color: Colors.green, text: 'CONFIRM');
        return child;
      case CardStatus.skip:
        final child =
            buildStamp(color: Color.fromARGB(255, 189, 0, 0), text: 'SKIP');
        return child;
      default:
        return Container();
    }
  }

  Widget buildStamp(
      {double angle = 0, required Color color, required String text}) {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 60),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: color, width: 4),
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style:
            TextStyle(color: color, fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildCard() => Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.55,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.file(File(widget.avtlink), fit: BoxFit.cover),
          ),
        ),
      );
}

class FindAnonymousGame extends StatefulWidget {
  const FindAnonymousGame({
    super.key,
    required this.avt,
    required this.listAnswer,
    required this.level,
    required this.numberOfAnswer,
    required this.time,
    this.contestId,
  });
  final String avt;
  final List<FindAnonymousAsset> listAnswer;
  final int level;
  final int numberOfAnswer;
  final int time;
  final int? contestId;
  @override
  State<StatefulWidget> createState() {
    return FindAnonymousGameState();
  }
}

class AnswerAnonymous {
  final String imageLink;
  final String description;

  AnswerAnonymous({required this.imageLink, required this.description});
}

class FindAnonymousGameState extends State<FindAnonymousGame>
    with TickerProviderStateMixin {
  bool roundVisible = true;
  late Animation<double> _opacityAnimation;
  late AnimationController _controller;
  bool scriptVisibile = false;
  bool findVisible = false;
  bool cardVisible = false;
  bool finishVisible = false;
  bool continueVisible = false;
  bool isWin = false;
  String description = '';
  String bgFinish = '';
  String btnContentFinish = '';
  bool tryAgainVisible = false;
  int progress = 0;
  bool loadingVisible = false;
  AudioPlayer au = AudioPlayer();
  AudioPlayer au2 = AudioPlayer();
  bool showBG = true;
  List<FindAnonymousAsset> listAnswer = [];
  List<String> lisAvt = [];
  Duration remainingTime = const Duration(seconds: 10);
  Timer? timer;
  bool _timerStarted = false;

  List<String> modifyList(List<String> inputList, List<String> listTmp) {
    List<String> modifiedList = List.from(inputList);
    modifiedList.shuffle();
    while (areAdjacent(modifiedList, listTmp) && widget.numberOfAnswer > 1) {
      modifiedList.shuffle();
      print('ec ec');
    }
    return modifiedList;
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    au2.dispose();
  }

  @override
  void initState() {
    au.setSourceAsset('sound/startgame.mp3').then((value) {
      au.setPlayerMode(PlayerMode.lowLatency);
      au.play(AssetSource('sound/startgame.mp3'));
    });
    au.onPlayerComplete.listen((event) {
      au.dispose();
    });
    print('vao vao');
    List<String> listTmp = [];
    setState(() {
      remainingTime = Duration(seconds: widget.time);
      for (var element in widget.listAnswer) {
        lisAvt.add(element.imgPath);
      }
      print('vao vao 1');
      for (int i = 1; i <= widget.numberOfAnswer; i++) {
        listAnswer.add(widget.listAnswer[i - 1]);
      }
      print('vao vao 2');
      for (var element in listAnswer) {
        description += '${element.description}\n';
        listTmp.add(element.imgPath);
      }
      print('vao vao 3');
    });

    lisAvt = modifyList(lisAvt, listTmp);

    print('vao vao 4');
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          lisAvt = lisAvt.reversed.toList();
          roundVisible = false;
          scriptVisibile = true;
          findVisible = true;
        });

        au2.setSourceAsset('sound/back2.mp3').then((value) {
          au2.setPlayerMode(PlayerMode.mediaPlayer);
          au2.play(AssetSource('sound/back2.mp3'));
        });

        au2.onPlayerComplete.listen((event) {
          au2.play(AssetSource('sound/back2.mp3'));
        });
      }
    });
    _controller.forward();

    super.initState();
  }

  bool checkIsAnswer(String imglink) {
    if (listAnswer.where((element) => element.imgPath == imglink).isNotEmpty) {
      return true;
    } else
      return false;
  }

  void lose() async {
    if (widget.contestId != null) {
      await ContestsAPI.addAccountInContest(
        (widget.time * 1000 - remainingTime.inMilliseconds).toDouble() / 1000,
        0,
        widget.contestId!,
      );
    }
    setState(() {
      finishVisible = true;
      continueVisible = true;
      tryAgainVisible = true;
      bgFinish = 'assets/pics/boo.png';
      timer?.cancel();
      isWin = false;
    });
    Future.delayed(const Duration(seconds: 3));
    continueFinish();
  }

  void continueFinish() async {
    if (isWin) {
      double points = (remainingTime.inMilliseconds / 1000);
      if (widget.contestId != null) {
        Account? account = await SharedPreferencesHelper.getInfo();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FinalResultScreen(
                  points: (points * 100).toInt(),
                  status: 'win',
                  gameId: games[2].id,
                  totalCoin:
                      account!.coin! + ((points * 100).toInt() / 10).toInt(),
                  contestId: widget.contestId!)),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WinScreen(
              haveTime: true,
              points: (points * 100).toInt(),
              time: (widget.time - remainingTime.inMilliseconds).toDouble() /
                  1000,
              isWin: true,
              gameName: games[2].name,
              gameId: games[2].id,
              contestId: widget.contestId,
            ),
          ),
          (route) => false,
        );
      }
    } else {
      if (widget.contestId != null) {
        Account? account = await SharedPreferencesHelper.getInfo();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FinalResultScreen(
                  points: 0,
                  status: 'lose',
                  gameId: games[2].id,
                  totalCoin: account!.coin!,
                  contestId: widget.contestId!)),
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
              gameName: games[2].name,
              gameId: games[2].id,
              contestId: widget.contestId,
            ),
          ),
          (route) => false,
        );
      }
    }
    if (isWin) {
      double points = (remainingTime.inMilliseconds / 1000);
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WinScreen(
            haveTime: true,
            points: (points * 100).toInt(),
            time:
                (widget.time * 1000 - remainingTime.inMilliseconds).toDouble() /
                    1000,
            isWin: true,
            gameId: 5,
            gameName: games[2].name,
            contestId: widget.contestId,
          ),
        ),
        (route) => false,
      );
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
            gameId: 5,
            gameName: games[2].name,
            contestId: widget.contestId,
          ),
        ),
        (route) => false,
      );
    }
  }

  void win() async {
    setState(() {
      isWin = true;
      finishVisible = true;
      bgFinish = 'assets/pics/cg.png';
      timer?.cancel();
    });
    double points = (remainingTime.inMilliseconds / 1000);

    if (widget.contestId == null) {
      int levelMax = await SharedPreferencesHelper.getAnonymousLevel();
      if (levelMax == widget.level) {
        await SharedPreferencesHelper.saveAnonymousLevel(widget.level + 1);
      }
      await ApiAchieviements.addAchieviements(
          (widget.time * 1000 - remainingTime.inMilliseconds).toDouble() / 1000,
          (points * 100).toInt(),
          widget.level,
          5,
          //account!.id,
          //account.accessToken!,
          widget.numberOfAnswer);
    } else {
      await ContestsAPI.addAccountInContest(
        (widget.time * 1000 - remainingTime.inMilliseconds).toDouble() / 1000,
        (points * 100).toInt(),
        widget.contestId!,
      );
    }
    Future.delayed(const Duration(seconds: 3));
    continueFinish();
  }

  void confirm(String imgLink) {
    if (checkIsAnswer(imgLink)) {
      setState(() {
        progress++;
      });
      if (progress == listAnswer.length) {
        win();
      }
    } else {
      setState(() {
        lose();
      });
    }
  }

  void reset() {
    setState(() {
      remainingTime = Duration(seconds: widget.time);
      isWin = false;
      scriptVisibile = false;
      findVisible = false;
      cardVisible = false;
      finishVisible = false;
      continueVisible = false;
      description = '';
      bgFinish = '';
      btnContentFinish = '';
      tryAgainVisible = false;
      progress = 0;
      loadingVisible = false;
      showBG = true;
      listAnswer = [];
      lisAvt = [];
      timer;
      List<String> listTmp = [];
      setState(() {
        for (var element in widget.listAnswer) {
          lisAvt.add(element.imgPath);
        }
        for (int i = 1; i <= widget.numberOfAnswer; i++) {
          listAnswer.add(widget.listAnswer[i - 1]);
        }
        for (var element in listAnswer) {
          description += '${element.description}\n';
          listTmp.add(element.imgPath);
        }
      });
      lisAvt = modifyList(lisAvt, listTmp);
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );
      _opacityAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            lisAvt = lisAvt.reversed.toList();
            roundVisible = false;
            scriptVisibile = true;
            findVisible = true;
          });
        }
      });
      _controller.forward();
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 543), (_) {
      setState(() {
        final newTime = remainingTime - const Duration(milliseconds: 543);
        if (newTime.isNegative) {
          timer!.cancel();
          setState(() {
            print('HẾt giờ');
            lose();
          });
        } else {
          remainingTime = newTime;
        }
      });
    });
  }

  void skip(String imgLink) {
    if (!checkIsAnswer(imgLink)) {
      print("Đúng, Chơi tiếp");
    } else {
      print("Sai, Cút");
    }
  }

  bool areAdjacent(List<String> objects, List<String> targetObjects) {
    int targetLength = targetObjects.length;
    for (int i = 0; i <= objects.length - targetLength; i++) {
      int n = 0;
      for (int j = 0; j < targetLength; j++) {
        if (targetObjects.contains(objects[i + j])) {
          n++;
        } else {
          break;
        }
      }
      if (n >= targetLength) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    final provider = Provider.of<CardProvider>(context);
    provider.urlImages = lisAvt;
    provider.confirmSet = confirm;
    provider.skipSet = skip;
    final urlImages = provider.urlImages;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.26,
        userAvatar: widget.avt,
        remainingTime: remainingTime,
        gameName: 'Find Anonymous',
        progressTitle: 'Found',
        progressMessage: '$progress/${listAnswer.length}',
        percent: progress / listAnswer.length,
        onPause: pause,
        onResume: resume,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage(
                  'assets/pics/bganonymous.png',
                ),
                opacity: showBG ? 1 : 0,
              ),
              color: const Color.fromRGBO(255, 240, 199, 1),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Visibility(
                  visible: cardVisible,
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              children: urlImages
                                  .map(
                                    (e) => AnonymousCard(
                                      avtlink: e,
                                      isFront: urlImages.last == e,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: loadingVisible,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: const Color.fromARGB(48, 0, 0, 0),
                    child: const Center(
                        child: CustomLoadingSpinner(
                            color: Color.fromARGB(255, 245, 149, 24))),
                  ),
                ),
                Visibility(
                  visible: roundVisible,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(153, 0, 0, 0)),
                  ),
                ),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Visibility(
                    visible: roundVisible,
                    child: Center(
                        child: TextWidget(
                      'Level ${widget.level}',
                      fontFamily: 'ButtonCustomFont',
                      fontSize: 70,
                      strokeColor: const Color.fromRGBO(255, 212, 96, 1),
                      strokeWidth: 20,
                      color: const Color.fromRGBO(240, 123, 63, 1),
                    )),
                  ),
                ),
                Visibility(
                  visible: scriptVisibile,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(0, 40, 30, 30),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                          ),
                          child: Text(
                            description,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: findVisible,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 76,
                        width: 336,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.8),
                                blurRadius: 7,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              _showResizableDialog(context);
                              setState(() {
                                findVisible = false;
                                scriptVisibile = false;
                                showBG = false;
                                cardVisible = true;
                                loadingVisible = true;
                              });
                              Future.delayed(const Duration(seconds: 4), () {
                                _closeDialog(context);
                                setState(() {
                                  loadingVisible = false;
                                  startTimer();
                                });
                              });
                            },
                            style: button1v1,
                            child: const Text(
                              'FIND',
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
          Visibility(
            visible: finishVisible,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(186, 0, 0, 0)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(bgFinish, height: 340),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Visibility(
                          //   visible: tryAgainVisible,
                          //   child: SizedBox(
                          //     height: 76,
                          //     width: 336,
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         color: const Color.fromRGBO(45, 64, 89, 1),
                          //         borderRadius: const BorderRadius.all(
                          //           Radius.circular(100),
                          //         ),
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black.withOpacity(0.8),
                          //             blurRadius: 7,
                          //             offset: const Offset(0, 5),
                          //           ),
                          //         ],
                          //       ),
                          //       child: ElevatedButton(
                          //         onPressed: () {
                          //           reset();
                          //         },
                          //         style: buttonLose,
                          //         child: const Text(
                          //           'TRY AGAIN',
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 30,
                          //             fontWeight: FontWeight.w900,
                          //             fontFamily: 'ButtonCustomFont',
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: continueVisible,
                            child: SizedBox(
                              height: 76,
                              width: 336,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 7,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    continueFinish();
                                  },
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
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
          width: 300,
          height: 350,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                "assets/pics/swap.png",
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Game Mechanics',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  "Swipe right if you find someone who matches the description and swipe left if the person doesn't match the description.",
                  style: TextStyle(
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
