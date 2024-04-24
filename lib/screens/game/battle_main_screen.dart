import 'dart:async';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/api/battle_api.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/main.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountbattle.dart';
import 'package:thinktank_mobile/models/battleinfo.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/battle/game_mainscreen.dart';
import 'package:thinktank_mobile/screens/musicpassword/musicpass_battle_mainscreen.dart';
import 'package:thinktank_mobile/widgets/game/level_item.dart';
import 'package:thinktank_mobile/widgets/game/top_user.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class BattleMainScreen extends StatefulWidget {
  const BattleMainScreen(
      {super.key,
      required this.account,
      required this.gameId,
      this.competitor,
      this.isWithFriend});
  final Account account;
  final int gameId;
  final AccountBattle? competitor;
  final bool? isWithFriend;

  @override
  State<BattleMainScreen> createState() => _BattleMainScreenState();
}

class _BattleMainScreenState extends State<BattleMainScreen> {
  bool isLoading = true;
  bool isWaiting = true;
  String roomID = '';
  bool isUser1 = true;
  bool isGetAccount1 = false;
  String _opponentName = '';
  String _opponentAvt = '';
  Timer? timer;
  bool isExit = true;
  int _opponentCoins = 0;
  late Future<AccountBattle?> findOpponent;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void dispose() {
    print('dispose');
    if (roomID.isNotEmpty) {
      BattleAPI.removeCache(widget.account.id, widget.gameId, 20, roomID, 0);
    }
    if (widget.isWithFriend != null &&
        widget.isWithFriend == true &&
        isUser1 &&
        isExit) {
      _databaseReference.child('battle').child(roomID).remove();
    }
    super.dispose();
  }

  void startTimer() async {
    Duration remainingTime = Duration(seconds: 90);
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      if (mounted) {
        final newTime = remainingTime - const Duration(milliseconds: 500);
        if (newTime.isNegative) {
          timer!.cancel();
          if (mounted) {
            _showResizableDialog(context);
            await Future.delayed(const Duration(seconds: 3));
            // ignore: use_build_context_synchronously
            _closeDialog(context);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }
        } else {
          remainingTime = newTime;
        }
      }
    });
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _showResizableDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            width: 250,
            height: 300,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(255, 249, 249, 249)),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/pics/toolong.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Waiting too long for your opponent!',
                    style: TextStyle(
                        color: Color.fromRGBO(234, 84, 85, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Text(
                      "There may be no one online in this mode",
                      style: TextStyle(
                          color: Color.fromRGBO(129, 140, 155, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.competitor == null) {
      findOpponent =
          BattleAPI.findOpponent(widget.account.id, widget.gameId, 20);

      startTimer();
      findOpponent.then((value) {
        if (value != null && value.accountId == 0) {
          print(value.roomId);
          roomID = value.roomId;
          _databaseReference.child('battle').child(value.roomId).set({
            'us1': widget.account.userName,
            'avt1': widget.account.avatar,
            'coin1': widget.account.coin,
            'progress1': 0,
            'id1': widget.account.id
          });
          _databaseReference
              .child('battle')
              .child(value.roomId)
              .onValue
              .listen((event) {
            if (event.snapshot.child('us2').exists && mounted) {
              joinGame(
                  event.snapshot.child('us2').value.toString(),
                  event.snapshot.child('avt2').value.toString(),
                  int.parse(event.snapshot.child('coin2').value.toString()),
                  isUser1,
                  int.parse(event.snapshot.child('id2').value.toString()));
            }
          });
        }
        if (value != null && value.accountId != 0) {
          print(value.roomId);
          setState(() {
            isUser1 = false;
          });
          roomID = value.roomId;
          _databaseReference.child('battle').child(value.roomId).update({
            'us2': widget.account.userName,
            'avt2': widget.account.avatar,
            'coin2': widget.account.coin,
            'progress2': 0,
            'id2': widget.account.id
          });
          joinGame(value.username!, value.avatar!, value.coin!, isUser1,
              value.accountId);
        }
      });
    } else {
      if (widget.competitor != null && widget.competitor!.accountId == 0) {
        print(widget.competitor!.roomId);
        roomID = widget.competitor!.roomId;
        _databaseReference
            .child('battle')
            .child(widget.competitor!.roomId)
            .set({
          'us1': widget.account.userName,
          'avt1': widget.account.avatar,
          'coin1': widget.account.coin,
          'progress1': 0,
          'id1': widget.account.id
        });
        _databaseReference
            .child('battle')
            .child(widget.competitor!.roomId)
            .onValue
            .listen((event) {
          if (event.snapshot.child('us2').exists && mounted) {
            joinGame(
                event.snapshot.child('us2').value.toString(),
                event.snapshot.child('avt2').value.toString(),
                int.parse(event.snapshot.child('coin2').value.toString()),
                isUser1,
                int.parse(event.snapshot.child('id2').value.toString()));
          }
        });
      }
      if (widget.competitor != null && widget.competitor!.accountId != 0) {
        print(widget.competitor!.roomId);
        setState(() {
          isUser1 = false;
        });
        roomID = widget.competitor!.roomId;
        _databaseReference
            .child('battle')
            .child(widget.competitor!.roomId)
            .update({
          'us2': widget.account.userName,
          'avt2': widget.account.avatar,
          'coin2': widget.account.coin,
          'progress2': 0,
          'id2': widget.account.id
        });
        AccountBattle compe =
            AccountBattle(accountId: 1, roomId: widget.competitor!.roomId);
        _databaseReference
            .child('battle')
            .child(widget.competitor!.roomId)
            .onValue
            .listen(
          (event) {
            if (!isGetAccount1) {
              isGetAccount1 = true;
              compe.accountId =
                  int.parse(event.snapshot.child('id1').value.toString());
              compe.username = event.snapshot.child('us1').value.toString();
              compe.avatar = event.snapshot.child('avt1').value.toString();
              compe.coin =
                  int.parse(event.snapshot.child('coin1').value.toString());
              joinGame(compe.username!, compe.avatar!, compe.coin!, isUser1,
                  compe.accountId);
            }
          },
        );
      }
    }
  }

  void joinGame(String opponentName, String opponentAvt, int coin, bool isUser1,
      int opponentId) async {
    isExit = false;
    if (mounted) {
      setState(() {
        _opponentName = opponentName;
        _opponentAvt = opponentAvt;
        _opponentCoins = coin;
        isLoading = false;
      });
      await Future.delayed(const Duration(seconds: 2));
      Account? account = await SharedPreferencesHelper.getInfo();
      if (account == null) return;
      if (mounted) {
        setState(() {
          isWaiting = true;
        });
      }

      await Future.delayed(Duration(seconds: 2));
      await BattleAPI.addAccountBattle(
        20,
        0,
        isUser1 ? account.id : opponentId,
        isUser1 ? opponentId : account.id,
        4,
        roomID,
        DateTime.now(),
      );
      if (widget.gameId == 4 && mounted) {
        BattleAPI.startBattle(roomID, isUser1, 100, -1);
        BattleAPI.remove1v1RoomDelay(roomID, 120);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => GameBattleMainScreen(
              isUSer1: isUser1,
              opponentAvt: _opponentAvt,
              opponentName: opponentName,
              account: account,
              gameName: 'Image walkthrough',
              levelNumber: 2,
              roomId: roomID,
              opponentId: opponentId,
              isWithFriend: widget.isWithFriend,
            ),
          ),
          (route) => false,
        );
        return;
      }
      // ignore: curly_braces_in_flow_control_structures, use_build_context_synchronously

      if (widget.gameId == 2 && mounted) {
        BattleAPI.startBattle(roomID, isUser1, 120, 0);
        BattleAPI.remove1v1RoomDelay(roomID, 140);
        var data = await getMusicPassword(4);
        data.time = 120;
        // ignore: curly_braces_in_flow_control_structures, use_build_c ontext_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPasswordGameBattle(
              isUSer1: isUser1,
              opponentAvt: _opponentAvt,
              opponentName: opponentName,
              account: account,
              gameName: 'Music password',
              levelNumber: 2,
              roomId: roomID,
              opponentId: opponentId,
              info: data,
              isWithFriend: widget.isWithFriend,
            ),
          ),
          (route) => false,
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return isLoading == true
        ? Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pics/vs_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: TopUser(
                      userAva: widget.account.avatar ??
                          "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
                      top: 4,
                      userName: widget.account.userName,
                      point: "${widget.account.coin ?? 0} coins",
                      isBordered: false,
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 6,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CustomLoadingSpinner(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/pics/vs_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        child: TopUser(
                          userAva: widget.account.avatar ??
                              "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
                          top: 6,
                          userName: widget.account.userName,
                          point: '${widget.account.coin ?? 0} coins',
                          isBordered: false,
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        left: 0,
                        right: 0,
                        child: TopUser(
                          userAva: _opponentAvt.isEmpty
                              ? "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688"
                              : _opponentAvt,
                          top: 5,
                          userName: _opponentName,
                          point: "$_opponentCoins coins",
                          isBordered: false,
                        ),
                      ),
                    ],
                  ),
                ),
                isWaiting == true
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(153, 0, 0, 0),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CustomLoadingSpinner(
                                color: Color.fromARGB(255, 255, 213, 96),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          );
  }
}
