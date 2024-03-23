import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/findanounymous_assets.dart';
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
            child: buildCard(),
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

  Widget buildCard() => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.file(File(widget.avtlink), fit: BoxFit.cover),
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
  });
  final String avt;
  final List<FindAnonymousAsset> listAnswer;
  final int level;
  final int numberOfAnswer;
  final int time;
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
  void initState() {
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

  void lose() {
    setState(() {
      finishVisible = true;
      continueVisible = true;
      tryAgainVisible = true;
      bgFinish = 'assets/pics/boo.png';
      timer?.cancel();
      isWin = false;
    });
  }

  void continueFinish() async {
    if (isWin) {
      double points = (remainingTime.inMilliseconds / 1000);
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
            gameId: 5,
            gameName: games[2].name,
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
    int levelMax = await SharedPreferencesHelper.getAnonymousLevel();
    if (levelMax == widget.level) {
      await SharedPreferencesHelper.saveAnonymousLevel(widget.level + 1);
    }
    Account? account = await SharedPreferencesHelper.getInfo();
    await ApiAchieviements.addAchieviements(
        (widget.time * 1000 - remainingTime.inMilliseconds).toDouble() / 1000,
        (points * 100).toInt(),
        widget.level,
        5,
        account!.id,
        account.accessToken!,
        widget.numberOfAnswer);
    setState(() {
      continueVisible = true;
    });
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
                    color: Color.fromARGB(48, 0, 0, 0),
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
                      'Round ${widget.level}',
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
                              setState(() {
                                findVisible = false;
                                scriptVisibile = false;
                                showBG = false;
                                cardVisible = true;
                                loadingVisible = true;
                              });
                              Future.delayed(const Duration(seconds: 3), () {
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
              decoration: BoxDecoration(color: Color.fromARGB(186, 0, 0, 0)),
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
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
                          Visibility(
                            visible: tryAgainVisible,
                            child: SizedBox(
                              height: 76,
                              width: 336,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(45, 64, 89, 1),
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
                                    reset();
                                  },
                                  style: buttonLose,
                                  child: const Text(
                                    'TRY AGAIN',
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
