import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thinktank_mobile/api/notification_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountbattle.dart';
import 'package:thinktank_mobile/models/notification_item.dart';
import 'package:thinktank_mobile/screens/game/battle_main_screen.dart';

class NotificationElement extends StatefulWidget {
  const NotificationElement({
    super.key,
    required this.notiEl,
    required this.handleReadNotification,
  });

  final NotificationItem notiEl;
  final Function() handleReadNotification;

  @override
  State<NotificationElement> createState() => _NotificationElementState();
}

class _NotificationElementState extends State<NotificationElement> {
  late String parsedDate;
  late DateTime formatDate;
  late StreamSubscription stream;

  late bool _isRead;

  @override
  void initState() {
    super.initState();

    formatDate = DateTime.parse(widget.notiEl.dateNotification!);
    parsedDate = DateFormat('MMM dd, yyyy').format(formatDate);
    _isRead = widget.notiEl.status!;
    print(_isRead);
  }

  Future<void> readNotification() async {
    bool status =
        await ApiNotification.updateStatusNotification(widget.notiEl.id!);

    if (status == true) {
      if (_isRead == false) {
        setState(() {
          _isRead = true;
        });
      }
    } else {
      print("Something went wrong!");
    }
  }

  void _showReject(BuildContext context, String content) {
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
                const SizedBox(height: 20),
                Image.asset(
                  'assets/pics/brainCry.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Can't play",
                    style: TextStyle(
                        color: Color.fromRGBO(234, 84, 85, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    content,
                    style: const TextStyle(
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

  void _showChallengeIsCancel(BuildContext context) {
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
                const SizedBox(height: 20),
                Image.asset(
                  'assets/pics/cancelChallenge.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Can't play",
                    style: TextStyle(
                        color: Color.fromRGBO(234, 84, 85, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Center(
                  child: Text(
                    'Your friend cancelled challenge request!',
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

  void _showWaiting(BuildContext context) {
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
                const SizedBox(height: 20),
                Image.asset(
                  'assets/animPics/start.gif',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Let's play",
                    style: TextStyle(
                        color: Color.fromRGBO(234, 84, 85, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Center(
                  child: Text(
                    'We are preparing for you!',
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

  Future<void> acceptChallenge(String roomId, int gameId) async {
    _showWaiting(context);
    Account? account = await SharedPreferencesHelper.getInfo();
    await readNotification();
    if (!(await FirebaseDatabase.instance
            .ref()
            .child('battle')
            .child(roomId)
            .get())
        .exists) {
      _showReject(context, 'Room is canceled');
      return;
    }

    int id1 = int.parse((await FirebaseDatabase.instance
            .ref()
            .child('battle')
            .child(roomId)
            .child('id1')
            .get())
        .value
        .toString());
    if (!await ApiAuthentication.checkOnline(id1)) {
      _showReject(context, 'Your friend is offline');
      return;
    }
    if (account!.coin! < 20) {
      _showReject(context, 'Your coin is not enough to play');
      return;
    }
    AccountBattle competitor = AccountBattle(accountId: 1, roomId: roomId);
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BattleMainScreen(
            account: account!,
            gameId: gameId,
            competitor: competitor,
            isWithFriend: true),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Column(
      children: [
        const SizedBox(
          height: 15.0,
        ),
        GestureDetector(
          onTap: () {
            if (widget.notiEl.title!
                .contains("ThinkTank Countervailing With Friend")) {
              List<String> parts = widget.notiEl.title!
                  .split(' '); // Chia chuỗi dựa vào khoảng trắng
              String roomAndGame = parts.last;

              List<String> twoParts = roomAndGame.split('/');
              String roomId = twoParts[0];
              int gameId = int.parse(twoParts[1]);

              print(roomId);
              print(gameId);

              print("true");
              if (_isRead != true) {
                _showConfirmDialog(context, () {
                  acceptChallenge(roomId, gameId);
                });
              } else {
                readNotification();
                widget.handleReadNotification();
              }
            } else {
              print("false");
              print(widget.notiEl.title);
              readNotification();
              widget.handleReadNotification();
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 14.0,
            ),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: _isRead == false
                  ? const Color.fromARGB(255, 44, 44, 44)
                  : Color.fromARGB(255, 22, 22, 22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(widget.notiEl.avatar!),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          right: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.notiEl.title!.contains(
                                    "ThinkTank Countervailing With Friend")
                                ? Text(
                                    "ThinkTank Countervailing With Friend",
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  )
                                : Text(
                                    widget.notiEl.title!,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                            Text(
                              widget.notiEl.description!,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              parsedDate,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _isRead == false
                        ? const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 240, 122, 63),
                            radius: 7.0,
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 7.0,
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void _showConfirmDialog(BuildContext context, Function accept) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Confirmation',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Accept challenge from your friend?',
          style: GoogleFonts.roboto(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'No',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _closeDialog(context);
              accept();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
