import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:thinktank_mobile/widgets/others/textstroke.dart';

class MusicPasswordGamePlay extends StatefulWidget {
  const MusicPasswordGamePlay({super.key});

  @override
  State<StatefulWidget> createState() {
    return MusicPasswordGamePlayState();
  }
}

class MusicPasswordGamePlayState extends State<MusicPasswordGamePlay> {
  static const maxTime = Duration(seconds: 10);
  Duration remainingTime = maxTime;
  Timer? timer;
  int numScript = 1;
  bool skipVisible = true;
  bool scriptVisibile = true;
  bool continueVisible = false;
  bool checkVisible = false;
  String pass = '';
  final audioPlayer = AudioPlayer();
  String bg = 'assets/pics/musicpassbng.png';
  String script =
      "Come on, James. You can do this. What's the password?\nJames closes his eyes, attempting to remember. Suddenly, he recalls the distinctive sound the digital door makes when he enters the password. He opens his eyes, a spark of realization in them.";

  void nhappass(String s) {
    setState(() {
      pass += s;
    });
  }

  void playSound() {
    final audioPlayer = AudioPlayer();
    audioPlayer.play(
      DeviceFileSource('assets/sound/test.mp3'),
    );
    // Đặt đường dẫn âm thanh của bạn
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 53), (_) {
      setState(() {
        final newTime = remainingTime - const Duration(milliseconds: 53);
        if (newTime.isNegative) {
          timer!.cancel();
          remainingTime = maxTime;
        } else {
          remainingTime = newTime;
        }
      });
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
        bg = 'assets/pics/nhappass.png';
      });
      return;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
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
                            onPressed: () {
                              startTimer();
                            },
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
                              millisecondsStr,
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
              visible: false,
              child: Container(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(153, 0, 0, 0)),
              ),
            ),
            Visibility(
              visible: false,
              child: Center(
                  child: TextWidget(
                'Round 1',
                fontFamily: 'ButtonCustomFont',
                fontSize: 70,
                strokeColor: const Color.fromRGBO(255, 212, 96, 1),
                strokeWidth: 20,
                color: const Color.fromRGBO(240, 123, 63, 1),
              )),
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
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 100),
                  height: MediaQuery.of(context).size.height * 0.6,
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
                          audioPlayer.play(
                            AssetSource('sound/sos.mp3'),
                          );
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
                          child: const Center(
                            child: Text(
                              'Tap here to listen the sound',
                              textAlign: TextAlign.center,
                              style: TextStyle(
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
                                  nhappass('1');
                                  final a = AudioPlayer();
                                  a.play(
                                    AssetSource('sound/buy.mp3'),
                                  );
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
                                  nhappass('2');
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
                                  nhappass('3');
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
                                  nhappass('4');
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
                                  nhappass('5');
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
                                  nhappass('6');
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
                                  nhappass('7');
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
                                  nhappass('8');
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
                                  nhappass('9');
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
                                  nhappass('*');
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
                                  nhappass('0');
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
                                  nhappass('#');
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
                      )
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
                        onPressed: () {},
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
