import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/api/battle_api.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/musicpassword.dart';
import 'package:thinktank_mobile/screens/contest/finalresult_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/battle_game_appbar.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:thinktank_mobile/widgets/others/textstroke.dart';
import 'package:thinktank_mobile/widgets/others/winscreen.dart';

class MusicPasswordGameBattle extends StatefulWidget {
  const MusicPasswordGameBattle({
    super.key,
    required this.info,
    required this.account,
    required this.gameName,
    required this.levelNumber,
    required this.roomId,
    required this.opponentName,
    required this.opponentAvt,
    required this.opponentId,
    required this.isUSer1,
    this.isWithFriend,
  });
  final MusicPassword info;
  final Account account;
  final String gameName;
  final int levelNumber;
  final String roomId;
  final String opponentName;
  final String opponentAvt;
  final int opponentId;
  final bool isUSer1;
  final bool? isWithFriend;

  @override
  State<StatefulWidget> createState() {
    return MusicPasswordGameBatleState();
  }
}

class MusicPasswordGameBatleState extends State<MusicPasswordGameBattle>
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
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<StreamSubscription<DatabaseEvent>> listEvent = [];
  bool chatVisible = false;
  String opponentName = '';
  String messgae = '';
  String progressOpponentId = '';
  String progressUserId = '';
  List<MessageChat> listMessage = [];
  bool roundVisible = true;
  bool _timerStarted = false;
  String pass = '';
  int progressOpponent = 5;
  bool isWin = false;
  AudioPlayer correctSound = AudioPlayer();
  AudioPlayer incorrectSound = AudioPlayer();
  AudioPlayer sound1 = AudioPlayer();
  AudioPlayer sound2 = AudioPlayer();
  AudioPlayer sound3 = AudioPlayer();
  AudioPlayer sound4 = AudioPlayer();
  AudioPlayer sound5 = AudioPlayer();
  bool isCompleted = false;
  AudioPlayer sound6 = AudioPlayer();
  AudioPlayer sound7 = AudioPlayer();
  AudioPlayer sound8 = AudioPlayer();
  DateTime startTime = DateTime.now();
  bool isIcon = false;
  AudioPlayer sound9 = AudioPlayer();
  AudioPlayer sound0 = AudioPlayer();
  AudioPlayer soundSao = AudioPlayer();
  AudioPlayer soundThang = AudioPlayer();
  String answer = '';
  int listenTime = 10;
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

  void win() async {
    double points = (remainingTime.inMilliseconds / 1000);

    setState(() {
      bg = 'assets/pics/winmuisc.png';
      checkVisible = false;
      enterPassVisible = false;
      script =
          "As James enters the last part of the password, the door emits a positive beep and unlocks. James can't hide his excitement.\nGot it! Who needs to remember a password when you've got rhythm?\nJames opens the door and steps inside, feeling a sense of accomplishment.";

      scriptVisibile = true;
      timer?.cancel();
    });
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
      if (int.parse(event.snapshot.value.toString()) == 0 && mounted) {
        print('Thắng rồi');
        Account? account = await SharedPreferencesHelper.getInfo();
        account!.coin = account.coin! + 20;
        await SharedPreferencesHelper.saveInfo(account);
        isCompleted = true;
        isCompleted = true;
        await BattleAPI.addResultBattle(
          20,
          account.id,
          widget.isUSer1 ? account.id : widget.opponentId,
          widget.isUSer1 ? widget.opponentId : account.id,
          2,
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
                    gameId: 2,
                    totalCoin: account.coin!,
                    contestId: null,
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
            account!.coin = account.coin! + 20;
            await SharedPreferencesHelper.saveInfo(account);
            isCompleted = true;
            await BattleAPI.addResultBattle(
              20,
              account.id,
              widget.isUSer1 ? account.id : widget.opponentId,
              widget.isUSer1 ? widget.opponentId : account.id,
              2,
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
                        gameId: 2,
                        totalCoin: account.coin!,
                        contestId: null,
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
              2,
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
                        gameId: 2,
                        totalCoin: account.coin!,
                        contestId: null,
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
              2,
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
                        gameId: 2,
                        totalCoin: account!.coin!,
                        contestId: null,
                        isWithFriend: widget.isWithFriend,
                      )),
              (route) => false,
            );
          }
        } else {
          print('Thắng do còn nhiều time hơn');
          Account? account = await SharedPreferencesHelper.getInfo();
          account!.coin = account.coin! + 20;
          await SharedPreferencesHelper.saveInfo(account);
          isCompleted = true;
          await BattleAPI.addResultBattle(
            20,
            account.id,
            widget.isUSer1 ? account.id : widget.opponentId,
            widget.isUSer1 ? widget.opponentId : account.id,
            2,
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
                      gameId: 2,
                      totalCoin: account.coin!,
                      contestId: null,
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
          if (remainingTime.inMilliseconds >
              int.parse(event.snapshot.value.toString())) {
            print('Thắng do còn nhiều time hơn');
            Account? account = await SharedPreferencesHelper.getInfo();
            account!.coin = account.coin! + 20;
            await SharedPreferencesHelper.saveInfo(account);
            isCompleted = true;
            await BattleAPI.addResultBattle(
              20,
              account.id,
              widget.isUSer1 ? account.id : widget.opponentId,
              widget.isUSer1 ? widget.opponentId : account.id,
              2,
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
                        gameId: 2,
                        totalCoin: account.coin!,
                        contestId: null,
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
              2,
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
                        gameId: 2,
                        totalCoin: account.coin!,
                        contestId: null,
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
              2,
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
                        gameId: 2,
                        totalCoin: account!.coin!,
                        contestId: null,
                        isWithFriend: widget.isWithFriend,
                      )),
              (route) => false,
            );
          }
        }
      }));
    }
  }

  void lose() async {
    setState(() {
      isWin = false;
      bg = 'assets/pics/losemusic.png';
      checkVisible = false;
      enterPassVisible = false;
      script = "Oh no. Jame can't remember password!\nHe can't open the door!";

      scriptVisibile = true;
      timer?.cancel();
    });

    setState(() {
      _databaseReference
          .child('battle')
          .child(widget.roomId)
          .child(progressUserId)
          .set(0);
    });
    listEvent.add(_databaseReference
        .child('battle')
        .child(widget.roomId)
        .child(progressOpponentId)
        .onValue
        .listen((event) async {
      if (int.parse(event.snapshot.value.toString()) == 0 && mounted) {
        print('Hòa - Cả 2 đều không hoàn thành');
        Account? account = await SharedPreferencesHelper.getInfo();
        isCompleted = true;
        await BattleAPI.addResultBattle(
          20,
          0,
          widget.isUSer1 ? account!.id : widget.opponentId,
          widget.isUSer1 ? widget.opponentId : account!.id,
          2,
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
                    gameId: 2,
                    totalCoin: account!.coin!,
                    contestId: null,
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
            2,
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
                      gameId: 2,
                      totalCoin: 0,
                      contestId: null,
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
            2,
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
                      gameId: 2,
                      totalCoin: 0,
                      contestId: null,
                      isWithFriend: widget.isWithFriend,
                    )),
            (route) => false,
          );
        }
      }));
    }
  }

  void skipScript() async {
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
    // if (isWin) {
    //   double points = (remainingTime.inMilliseconds / 1000);
    //   if (widget.contestId != null) {
    //     Account? account = await SharedPreferencesHelper.getInfo();
    //     // ignore: use_build_context_synchronously
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => FinalResultScreen(
    //               points: (points * 100).toInt(),
    //               status: 'win',
    //               gameId: 2,
    //               totalCoin:
    //                   account!.coin! + ((points * 100).toInt() / 10).toInt(),
    //               contestId: widget.contestId!)),
    //       (route) => false,
    //     );
    //   } else {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => WinScreen(
    //           haveTime: true,
    //           points: (points * 100).toInt(),
    //           time: (maxTime.inMilliseconds - remainingTime.inMilliseconds)
    //                   .toDouble() /
    //               1000,
    //           isWin: true,
    //           gameName: widget.gameName,
    //           gameId: 2,
    //           contestId: widget.contestId,
    //         ),
    //       ),
    //       (route) => false,
    //     );
    //   }
    // } else {
    //   if (widget.contestId != null) {
    //     Account? account = await SharedPreferencesHelper.getInfo();
    //     // ignore: use_build_context_synchronously
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => FinalResultScreen(
    //               points: 0,
    //               status: 'lose',
    //               gameId: 2,
    //               totalCoin: account!.coin!,
    //               contestId: widget.contestId!)),
    //       (route) => false,
    //     );
    //   } else {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => WinScreen(
    //           haveTime: false,
    //           points: 0,
    //           time: 0,
    //           isWin: false,
    //           gameName: widget.gameName,
    //           gameId: 2,
    //           contestId: widget.contestId,
    //         ),
    //       ),
    //       (route) => false,
    //     );
    //   }
    // }
  }

  @override
  void dispose() {
    timer?.cancel();
    if (!isCompleted) {
      _databaseReference
          .child('battle')
          .child(widget.roomId)
          .child(progressUserId)
          .set(0);
    }
    audioPlayer.dispose();
    for (var element in listEvent) {
      element.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _databaseReference
        .child('battle')
        .child(widget.roomId)
        .child('chat')
        .onChildAdded
        .listen((event) async {
      print(event.snapshot.value.toString());
      if (event.snapshot.value.toString().length >=
              widget.opponentName.length &&
          event.snapshot.value
                  .toString()
                  .substring(0, widget.opponentName.length) ==
              widget.opponentName &&
          mounted) {
        listMessage.add(MessageChat(
          isOwner: false,
          content: event.snapshot.value
              .toString()
              .substring(widget.opponentName.length + 3),
          name: widget.opponentName,
          idOpponent: widget.opponentId,
        ));
        setState(() {
          chatVisible = true;
          listMessage;
          messgae = event.snapshot.value
              .toString()
              .substring(widget.opponentName.length + 3);
        });
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          chatVisible = false;
        });
      } else {
        listMessage.add(MessageChat(
          isOwner: true,
          content: event.snapshot.value
              .toString()
              .substring(widget.account.userName.length + 3),
          name: widget.account.userName,
          idOpponent: null,
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
          isIcon = true;
          messgae = event.snapshot.value
              .toString()
              .substring(widget.opponentName.length + 3);
        });
        await Future.delayed(Duration(seconds: 4));
        setState(() {
          chatVisible = false;
          isIcon = false;
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
    _databaseReference
        .child('battle')
        .child(widget.roomId)
        .child(progressUserId)
        .set(widget.info.change);
    listEvent.add(_databaseReference
        .child('battle')
        .child(widget.roomId)
        .child(progressOpponentId)
        .onValue
        .listen((event) {
      setState(() {
        if (int.parse(event.snapshot.value.toString()) >= 0 && mounted) {
          progressOpponent = int.parse(event.snapshot.value.toString());
        }
      });
    }));

    setSound();
    au.setSourceAsset('sound/startgame.mp3').then((value) {
      au.play(AssetSource('sound/startgame.mp3'));
    });

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
              numScript == 3;
              roundVisible = false;
              scriptVisibile = false;
              continueVisible = false;
              enterPassVisible = true;
              checkVisible = true;
              bg = 'assets/pics/nhappass.png';
              startTimer();
              numScript++;
            });
          },
        );
      }
    });
    _controller.forward();
    audioPlayer.setSourceUrl(widget.info.soundLink);
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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TBattleGameAppBar(
        percentOpponent: progressOpponent / widget.info.change,
        progressMessageOpponent: '$progressOpponent/${widget.info.change}',
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
        progressMessage: '$remainChange/${widget.info.change}',
        percent: remainChange / widget.info.change,
        onPause: () {},
        onResume: () {},
        isIcon: isIcon,
      ),
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
                  "Let's go",
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
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8,
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
                          setState(() {
                            if (audioPlayer.state != PlayerState.playing &&
                                listenTime > 0 &&
                                isListenAlready) {
                              listenTime = listenTime - 1;
                              isListenAlready = false;
                              audioPlayer.play(
                                  DeviceFileSource(widget.info.soundLink));
                              // audioPlayer
                              //     .play(UrlSource(widget.info.soundLink));
                              audioPlayer.onPlayerComplete.listen((event) {
                                isListenAlready = true;
                              });
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          height: 50,
                          width: 140,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(122, 122, 122, 0.63),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              'Listen ($listenTime)',
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
                          top: 10,
                        ),
                        width: MediaQuery.of(context).size.width - 150,
                        height: 50,
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
                          top: 10,
                          left: 50,
                          right: 50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () async {
                                  sound1.play(
                                      AssetSource('sound/${listNote[0]}.mp3'),
                                      volume: 1000);
                                  sound1 = AudioPlayer();
                                  await sound1.setSourceAsset(
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
                                onPressed: () async {
                                  sound2.play(
                                      AssetSource('sound/${listNote[1]}.mp3'));
                                  nhappass('2', listNote[1]);
                                  sound2 = AudioPlayer();
                                  await sound2.setSourceAsset(
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
                                onPressed: () async {
                                  sound3.play(
                                      AssetSource('sound/${listNote[2]}.mp3'));
                                  sound3 = AudioPlayer();
                                  await sound3.setSourceAsset(
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
                          top: 10,
                          left: 50,
                          right: 50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () async {
                                  sound4.play(
                                      AssetSource('sound/${listNote[3]}.mp3'));
                                  sound4 = AudioPlayer();
                                  await sound4.setSourceAsset(
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
                                onPressed: () async {
                                  sound5.play(
                                      AssetSource('sound/${listNote[4]}.mp3'));
                                  sound5 = AudioPlayer();
                                  await sound5.setSourceAsset(
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
                                onPressed: () async {
                                  sound6.play(
                                      AssetSource('sound/${listNote[5]}.mp3'));
                                  sound6 = AudioPlayer();
                                  await sound6.setSourceAsset(
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
                          top: 10,
                          left: 50,
                          right: 50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () async {
                                  sound7.play(
                                      AssetSource('sound/${listNote[6]}.mp3'));
                                  sound7 = AudioPlayer();
                                  await sound7.setSourceAsset(
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
                                onPressed: () async {
                                  sound8.play(
                                      AssetSource('sound/${listNote[7]}.mp3'));
                                  sound8 = AudioPlayer();
                                  await sound8.setSourceAsset(
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
                                onPressed: () async {
                                  sound9.play(
                                      AssetSource('sound/${listNote[8]}.mp3'));
                                  sound9 = AudioPlayer();
                                  await sound9.setSourceAsset(
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
                          top: 10,
                          left: 50,
                          right: 50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () async {
                                  soundSao.play(
                                      AssetSource('sound/${listNote[9]}.mp3'));
                                  soundSao = AudioPlayer();
                                  await soundSao.setSourceAsset(
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
                                onPressed: () async {
                                  sound0.play(
                                      AssetSource('sound/${listNote[10]}.mp3'));
                                  sound0 = AudioPlayer();
                                  await sound0.setSourceAsset(
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
                                onPressed: () async {
                                  soundThang.play(
                                      AssetSource('sound/${listNote[11]}.mp3'));
                                  soundThang = AudioPlayer();
                                  await soundThang.setSourceAsset(
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
                        margin: const EdgeInsets.only(top: 10),
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
                      Visibility(
                        visible: checkVisible,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 60,
                              width: 200,
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
                                    if (remainChange >= 1) {
                                      if (check()) {
                                        correctSound.play(
                                            AssetSource('sound/correct.mp3'));
                                        correctSound = AudioPlayer();
                                        setState(() {
                                          isWin = true;
                                          win();
                                        });
                                      } else {
                                        setState(() {
                                          incorrectSound.play(AssetSource(
                                              'sound/incorrect.mp3'));
                                          incorrectSound = AudioPlayer();
                                          remainChange -= 1;
                                          _databaseReference
                                              .child('battle')
                                              .child(widget.roomId)
                                              .child(progressUserId)
                                              .set(remainChange);
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
