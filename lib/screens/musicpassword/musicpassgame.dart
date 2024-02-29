import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/models/musicpassword.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:thinktank_mobile/widgets/others/textstroke.dart';
import 'package:thinktank_mobile/widgets/others/winscreen.dart';

class MusicPasswordGamePlay extends StatefulWidget {
  const MusicPasswordGamePlay({super.key, required this.info});
  final MusicPassword info;

  @override
  State<StatefulWidget> createState() {
    return MusicPasswordGamePlayState();
  }
}

class MusicPasswordGamePlayState extends State<MusicPasswordGamePlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  List<String> listNote = [
    'c1',
    'd1',
    'e1',
    'f1',
    'g1',
    'a1',
    'b1',
    'c2',
    'd2',
    'e2',
    'f2',
    'g2'
  ];
  Duration maxTime = const Duration(seconds: 10);
  Duration remainingTime = const Duration(seconds: 10);
  int remainChange = 0;
  Timer? timer;
  int numScript = 1;
  bool skipVisible = false;
  bool scriptVisibile = false;
  bool continueVisible = false;
  bool checkVisible = false;
  bool isListenAlready = true;
  bool enterPassVisible = false;
  bool roundVisible = true;
  String pass = '';
  bool isWin = false;
  AudioPlayer correctSound = AudioPlayer();
  AudioPlayer incorrectSound = AudioPlayer();
  AudioPlayer sound1 = AudioPlayer();
  AudioPlayer sound2 = AudioPlayer();
  AudioPlayer sound3 = AudioPlayer();
  AudioPlayer sound4 = AudioPlayer();
  AudioPlayer sound5 = AudioPlayer();
  AudioPlayer sound6 = AudioPlayer();
  AudioPlayer sound7 = AudioPlayer();
  AudioPlayer sound8 = AudioPlayer();
  AudioPlayer sound9 = AudioPlayer();
  AudioPlayer sound0 = AudioPlayer();
  AudioPlayer soundSao = AudioPlayer();
  AudioPlayer soundThang = AudioPlayer();
  String answer = '';
  int listenTime = 5;
  final audioPlayer = AudioPlayer();
  AudioPlayer au = AudioPlayer();
  String bg = 'assets/pics/musicpassbng.png';
  String script =
      "Come on, James. You can do this. What's the password?\nJames closes his eyes, attempting to remember. Suddenly, he recalls the distinctive sound the digital door makes when he enters the password. He opens his eyes, a spark of realization in them.";

  void nhappass(String s, String note) {
    setState(() {
      pass += s;
      answer += note;
    });
  }

  List<String> shuffleList(List<String> list) {
    final random = Random();
    for (int i = list.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      // Swap phần tử tại vị trí i và j
      String temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
    return list;
  }

  void setSound() {
    listNote.shuffle();
    for (var s in listNote) {
      print(s);
    }
    correctSound.setSourceAsset('sound/correct.mp3');
    incorrectSound.setSourceAsset('sound/incorrect.mp3');
    sound1.setSourceAsset('sound/${listNote[0]}.mp3');
    sound2.setSourceAsset('sound/${listNote[1]}.mp3');
    sound3.setSourceAsset('sound/${listNote[2]}.mp3');
    sound4.setSourceAsset('sound/${listNote[3]}.mp3');
    sound5.setSourceAsset('sound/${listNote[4]}.mp3');
    sound6.setSourceAsset('sound/${listNote[5]}.mp3');
    sound7.setSourceAsset('sound/${listNote[6]}.mp3');
    sound8.setSourceAsset('sound/${listNote[7]}.mp3');
    sound9.setSourceAsset('sound/${listNote[8]}.mp3');
    soundSao.setSourceAsset('sound/${listNote[9]}.mp3');
    sound0.setSourceAsset('sound/${listNote[10]}.mp3');
    soundThang.setSourceAsset('sound/${listNote[11]}.mp3');
  }

  void delete() {
    setState(() {
      if (pass.isNotEmpty) {
        pass = pass.substring(0, pass.length - 1);
      }
      if (answer.isNotEmpty) {
        answer = answer.substring(0, answer.length - 2);
      }
    });
  }

  bool check() {
    if (answer == widget.info.answer) return true;
    return false;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 543), (_) {
      setState(() {
        final newTime = remainingTime - const Duration(milliseconds: 543);
        if (newTime.isNegative) {
          timer!.cancel();
          setState(() {
            lose();
          });
        } else {
          remainingTime = newTime;
        }
      });
    });
  }

  void win() {
    setState(() {
      bg = 'assets/pics/winmuisc.png';
      checkVisible = false;
      enterPassVisible = false;
      script =
          "As James enters the last part of the password, the door emits a positive beep and unlocks. James can't hide his excitement.\nGot it! Who needs to remember a password when you've got rhythm?\nJames opens the door and steps inside, feeling a sense of accomplishment.";
      continueVisible = true;
      scriptVisibile = true;
      timer?.cancel();
    });
  }

  void lose() {
    setState(() {
      isWin = false;
      bg = 'assets/pics/winmusic.png';
      checkVisible = false;
      enterPassVisible = false;
      script = "Oh no. Jame can't remember password!\nHe can't open the door!";
      continueVisible = true;
      scriptVisibile = true;
      timer?.cancel();
    });
  }

  void skipScript() {
    if (numScript == 1) {
      setState(() {
        script =
            "Ah, yes! The sound!\nJames mimics the sound, tapping his fingers on the table. He listens intently, analyzing the rhythm.";
      });
      numScript++;
      return;
    }
    if (numScript == 2) {
      setState(() {
        script =
            "James grins as he recognizes the pattern. He takes a deep breath, ready to give it a try.";
      });
      numScript++;
      skipVisible = false;
      continueVisible = true;
      return;
    }
    if (numScript == 3) {
      setState(() {
        scriptVisibile = false;
        continueVisible = false;
        enterPassVisible = true;
        checkVisible = true;
        bg = 'assets/pics/nhappass.png';
      });
      startTimer();
      numScript++;
      return;
    }
    if (isWin) {
      double points = (remainingTime.inMilliseconds / 1000);
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
          ),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const WinScreen(
            haveTime: false,
            points: 0,
            time: 0,
            isWin: false,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setSound();
    au.setSourceAsset('sound/startgame.mp3');
    au.play(AssetSource('sound/startgame.mp3'));
    au.onPlayerComplete.listen((event) {
      au.dispose();
    });
    setState(() {
      maxTime = Duration(seconds: widget.info.time);
      remainingTime = maxTime;
      remainChange = widget.info.change;
    });
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
        Future.delayed(
          const Duration(seconds: 1),
          () {
            setState(() {
              roundVisible = false;
              scriptVisibile = true;
              skipVisible = true;
            });
          },
        );
      }
    });
    _controller.forward();
    audioPlayer.setSourceUrl(widget.info.soundLink);
  }

  @override
  Widget build(BuildContext context) {
    final minutesStr =
        (remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final secondsStr =
        (remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    final millisecondsStr = (remainingTime.inMilliseconds % 1000)
        .toString()
        .padLeft(2, '0')
        .substring(0, 2);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              bg,
            ),
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(255, 153, 0, 1),
                        Color.fromRGBO(234, 67, 53, 1),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 40,
                              weight: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 212, 96, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              minutesStr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          ' : ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 212, 96, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              secondsStr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          ' - ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(242, 153, 115, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              remainChange.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/pics/musicpassbng.png'),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: roundVisible,
              child: Container(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(153, 0, 0, 0)),
              ),
            ),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Visibility(
                visible: roundVisible,
                child: Center(
                    child: TextWidget(
                  'Round ' + widget.info.level.toString(),
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
                      width: MediaQuery.of(context).size.width - 30,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(93, 0, 0, 0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: Text(
                        script,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Visibility(
                      visible: skipVisible,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 30, top: 10),
                          child: InkWell(
                            onTap: skipScript,
                            child: const Text(
                              'Skip >>',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: continueVisible,
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
                        onPressed: skipScript,
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
            Visibility(
              visible: enterPassVisible,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 100),
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          isListenAlready = false;
                          if (audioPlayer.state != PlayerState.playing &&
                              listenTime > 0 &&
                              isListenAlready) {
                            audioPlayer.play(UrlSource(widget.info.soundLink));
                            audioPlayer.onPlayerComplete.listen((event) {
                              listenTime -= 1;
                              isListenAlready = true;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                          ),
                          height: 70,
                          width: 175,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(122, 122, 122, 0.63),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              'Tap here to listen the sound ($listenTime)',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 30,
                        ),
                        width: MediaQuery.of(context).size.width - 100,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(122, 122, 122, 0.63),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          pass,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 60,
                          right: 60,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound1.play(
                                      AssetSource('sound/${listNote[0]}.mp3'),
                                      volume: 1000);
                                  sound1 = AudioPlayer();
                                  sound1.setSourceAsset(
                                      'sound/${listNote[0]}.mp3');
                                  nhappass('1', listNote[0]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '1',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound2.play(
                                      AssetSource('sound/${listNote[1]}.mp3'));
                                  nhappass('2', listNote[1]);
                                  sound2 = AudioPlayer();
                                  sound2.setSourceAsset(
                                      'sound/${listNote[1]}.mp3');
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '2',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound3.play(
                                      AssetSource('sound/${listNote[2]}.mp3'));
                                  sound3 = AudioPlayer();
                                  sound3.setSourceAsset(
                                      'sound/${listNote[2]}.mp3');
                                  nhappass('3', listNote[2]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '3',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 60,
                          right: 60,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound4.play(
                                      AssetSource('sound/${listNote[3]}.mp3'));
                                  sound4 = AudioPlayer();
                                  sound4.setSourceAsset(
                                      'sound/${listNote[3]}.mp3');
                                  nhappass('4', listNote[3]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '4',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound5.play(
                                      AssetSource('sound/${listNote[4]}.mp3'));
                                  sound5 = AudioPlayer();
                                  sound5.setSourceAsset(
                                      'sound/${listNote[4]}.mp3');
                                  nhappass('5', listNote[4]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '5',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound6.play(
                                      AssetSource('sound/${listNote[5]}.mp3'));
                                  sound6 = AudioPlayer();
                                  sound6.setSourceAsset(
                                      'sound/${listNote[5]}.mp3');
                                  nhappass('6', listNote[5]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '6',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 60,
                          right: 60,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound7.play(
                                      AssetSource('sound/${listNote[6]}.mp3'));
                                  sound7 = AudioPlayer();
                                  sound7.setSourceAsset(
                                      'sound/${listNote[6]}.mp3');
                                  nhappass('7', listNote[6]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '7',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound8.play(
                                      AssetSource('sound/${listNote[7]}.mp3'));
                                  sound8 = AudioPlayer();
                                  sound8.setSourceAsset(
                                      'sound/${listNote[7]}.mp3');
                                  nhappass('8', listNote[7]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '8',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound9.play(
                                      AssetSource('sound/${listNote[8]}.mp3'));
                                  sound9 = AudioPlayer();
                                  sound9.setSourceAsset(
                                      'sound/${listNote[8]}.mp3');
                                  nhappass('9', listNote[8]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '9',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 60,
                          right: 60,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  soundSao.play(
                                      AssetSource('sound/${listNote[9]}.mp3'));
                                  soundSao = AudioPlayer();
                                  soundSao.setSourceAsset(
                                      'sound/${listNote[9]}.mp3');
                                  nhappass('*', listNote[9]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '*',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  sound0.play(
                                      AssetSource('sound/${listNote[10]}.mp3'));
                                  sound0 = AudioPlayer();
                                  sound0.setSourceAsset(
                                      'sound/${listNote[10]}.mp3');
                                  nhappass('0', listNote[10]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  soundThang.play(
                                      AssetSource('sound/${listNote[11]}.mp3'));
                                  soundThang = AudioPlayer();
                                  soundThang.setSourceAsset(
                                      'sound/${listNote[11]}.mp3');
                                  nhappass('#', listNote[11]);
                                },
                                style: buttonPass,
                                child: const Center(
                                  child: Text(
                                    '#',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      fontSize: 25,
                                      shadows: [
                                        BoxShadow(
                                          color: Color.fromRGBO(234, 84, 85, 1),
                                          blurRadius: 10,
                                          spreadRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: ElevatedButton(
                            onPressed: delete,
                            style: buttonPass,
                            child: const Center(
                              child: Text(
                                'X',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(234, 84, 85, 1),
                                  fontSize: 25,
                                  shadows: [
                                    BoxShadow(
                                      color: Color.fromRGBO(234, 84, 85, 1),
                                      blurRadius: 10,
                                      spreadRadius: 10,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
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
            ),
            Visibility(
              visible: checkVisible,
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
                        onPressed: () {
                          if (remainChange >= 1) {
                            if (check()) {
                              correctSound
                                  .play(AssetSource('sound/correct.mp3'));
                              correctSound = AudioPlayer();
                              correctSound.setSourceAsset('sound/correct.mp3');
                              setState(() {
                                isWin = true;
                                win();
                              });
                            } else {
                              setState(() {
                                incorrectSound
                                    .play(AssetSource('sound/incorrect.mp3'));
                                incorrectSound = AudioPlayer();
                                incorrectSound
                                    .setSourceAsset('sound/incorrect.mp3');
                                remainChange -= 1;
                              });
                              if (remainChange <= 0) {
                                setState(() {
                                  lose();
                                });
                              }
                            }
                          }
                        },
                        style: button1v1,
                        child: const Text(
                          'CHECK',
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
    );
  }
}
