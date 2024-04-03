import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/api/battle_api.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountbattle.dart';
import 'package:thinktank_mobile/models/battleinfo.dart';
import 'package:thinktank_mobile/screens/imagesWalkthrough/battle/game_mainscreen.dart';
import 'package:thinktank_mobile/widgets/game/top_user.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class BattleMainScreen extends StatefulWidget {
  const BattleMainScreen(
      {super.key, required this.account, required this.gameId});
  final Account account;
  final int gameId;

  @override
  State<BattleMainScreen> createState() => _BattleMainScreenState();
}

class _BattleMainScreenState extends State<BattleMainScreen> {
  bool isLoading = true;
  bool isWaiting = true;
  String roomID = '';
  bool isUser1 = true;
  String _opponentName = '';
  String _opponentAvt = '';
  int _opponentCoins = 0;
  late Future<AccountBattle?> findOpponent;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    findOpponent = BattleAPI.findOpponent(widget.account.id, widget.gameId, 20);
    findOpponent.then((value) {
      if (value != null && value.accountId == 0) {
        print(value.roomId);
        roomID = value.roomId;
        _databaseReference.child('battle').child(value.roomId).set({
          'us1': widget.account.userName,
          'avt1': widget.account.avatar,
          'coin1': widget.account.coin,
        });
        _databaseReference
            .child('battle')
            .child(value.roomId)
            .onValue
            .listen((event) {
          if (event.snapshot.child('us2').exists) {
            joinGame(
                event.snapshot.child('us2').value.toString(),
                event.snapshot.child('avt2').value.toString(),
                int.parse(event.snapshot.child('coin2').value.toString()));
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
        });
        joinGame(value.username!, value.avatar!, value.coin!);
      }
      if (value != null) {}
    });
  }

  void joinGame(String opponentName, String opponentAvt, int coin) async {
    if (mounted) {
      setState(() {
        _opponentName = opponentName;
        _opponentAvt = opponentAvt;
        _opponentCoins = coin;
        isLoading = false;
      });
      await Future.delayed(const Duration(seconds: 3));
      Account? account = await SharedPreferencesHelper.getInfo();
      if (account == null) return;
      setState(() {
        isWaiting = true;
      });
      await Future.delayed(Duration(seconds: 3));
      if (widget.gameId == 4)
        // ignore: curly_braces_in_flow_control_structures, use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => GameBattleMainScreen(
                opponentName: opponentName,
                account: account,
                gameName: 'Image walkthroug',
                levelNumber: 0,
                roomId: roomID),
          ),
          (route) => false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {},
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
                          point: "20 coins",
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
                          point: "$_opponentCoins points",
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
