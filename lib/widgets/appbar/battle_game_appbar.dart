import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:thinktank_mobile/api/icon_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/icon.dart';
import 'package:thinktank_mobile/screens/game/game_menu.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:unicons/unicons.dart';

class MessageChat extends StatelessWidget {
  const MessageChat(
      {super.key,
      required this.isOwner,
      required this.content,
      required this.name});
  final bool isOwner;
  final String content;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10),
      child: Row(
        children: [
          Text(
            '$name: ',
            style: TextStyle(
                fontSize: 18,
                color: isOwner
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : const Color.fromARGB(255, 240, 122, 63),
                fontWeight: FontWeight.bold),
          ),
          Text(
            content,
            style: TextStyle(
                fontSize: 18,
                color: isOwner
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : const Color.fromARGB(255, 87, 87, 87)),
          ),
        ],
      ),
    );
  }
}

class TBattleGameAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TBattleGameAppBar({
    super.key,
    required this.preferredHeight,
    required this.userAvatar,
    required this.competitorAvatar,
    required this.remainingTime,
    required this.gameName,
    required this.progressTitle,
    required this.progressMessage,
    required this.percent,
    required this.onPause,
    required this.onResume,
    required this.roomId,
    required this.userName,
    required this.messgae,
    required this.chatVisible,
    required this.listMessage,
    required this.progressTitleOpponent,
    required this.progressMessageOpponent,
    required this.percentOpponent,
  });

  final double preferredHeight;
  final String userAvatar;
  final String competitorAvatar;
  final Duration remainingTime;
  final String gameName;
  final String progressTitle;
  final String progressMessage;
  final double percent;
  final String progressTitleOpponent;
  final String progressMessageOpponent;
  final double percentOpponent;
  final String roomId;
  final void Function() onPause;
  final void Function() onResume;
  final String userName;
  final String messgae;
  final bool chatVisible;
  final List<MessageChat> listMessage;

  @override
  State<TBattleGameAppBar> createState() => _TBattleGameAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class _TBattleGameAppBarState extends State<TBattleGameAppBar> {
  bool isLoading = true;
  List<IconApp> icons = [];

  Future displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 15.0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 180.0,
              height: 180.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pics/brainCry.png"),
                ),
              ),
            ),
            Text(
              "Wait, you're about to win!",
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: Text(
                "Quitting the game midway can affect your memory improvement progress.",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 70, 70, 70),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 58, 82, 114),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: buttonYesBottomSheet(context),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onResume();
                },
                child: const Text(
                  "Continue the game",
                  style: TextStyle(
                    fontFamily: 'ButtonCustomFont',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: () {
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return GameMenuScreen(game: game!);
                //     },
                //   ),
                //   (route) => false,
                // );
              },
              child: Text(
                "Quit game",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 234, 84, 84),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future displayBottomSheetChat(BuildContext context, String roomId) {
    TextEditingController messageContoller = TextEditingController();
    DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    void sendMessage(String message) {
      if (mounted) {
        DatabaseReference newChat = _databaseReference
            .child('battle')
            .child(widget.roomId)
            .child('chat')
            .push();
        newChat.set("${widget.userName} : $message");
      }
    }

    Future getIconData() async {
      icons = await SharedPreferencesHelper.getIconSources();
      setState(() {
        icons;
      });
    }

    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(61, 129, 140, 155),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageContoller,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Type your message",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 102, 102, 102),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors
                                      .transparent, // Màu viền khi có focus
                                  width: 1,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 7.0,
                                horizontal: 10.0,
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(69, 189, 189, 189),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                          ),
                          onPressed: () {
                            if (messageContoller.text.trim().isNotEmpty) {
                              sendMessage(messageContoller.text);
                              messageContoller.clear();
                            }
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            //  await displayIcons(context);
                            await getIconData().then((value) {
                              //   Navigator.of(context).pop();
                              displayIcons(context);
                            });
                          },
                          icon: const Icon(
                            Icons.emoji_emotions,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: StreamBuilder<Object>(
                            stream: _databaseReference
                                .child('battle')
                                .child(widget.roomId)
                                .child('chat')
                                .onChildAdded,
                            builder: (context, snapshot) {
                              return Column(
                                children: widget.listMessage,
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future displayIcons(BuildContext context) async {
    // ignore: use_build_context_synchronously
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(61, 129, 140, 155),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: icons.map((iconData) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(iconData.iconAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final minutesStr =
        (widget.remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final secondsStr =
        (widget.remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    final millisecondsStr = (widget.remainingTime.inMilliseconds % 1000)
        .toString()
        .padLeft(2, '0')
        .substring(0, 2);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        height: widget.preferredHeight,
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
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Text(
                      widget.gameName,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 255, 255, 255), // Border color
                              width: 3.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 25, // Avatar radius
                            backgroundImage: NetworkImage(widget
                                .userAvatar), // Your avatar image URL here
                          ),
                        ),
                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/pics/vs_1.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 255, 255, 255), // Border color
                              width: 3.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 25, // Avatar radius
                            backgroundImage: NetworkImage(widget
                                .competitorAvatar), // Your avatar image URL here
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ' : ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            displayBottomSheetChat(context, widget.roomId);
                            widget.onPause();
                          },
                          icon: const Icon(
                            UniconsLine.ellipsis_v,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.progressTitle,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.progressMessage,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: LinearPercentIndicator(
                      //width: MediaQuery.of(context).size.width * 0.9,
                      animation: true,
                      lineHeight: 25.0,
                      animationDuration: 1000,
                      animateFromLastPercent: true,
                      percent: widget.percent,
                      barRadius: const Radius.circular(20.0),
                      progressColor: const Color.fromRGBO(255, 212, 96, 1),
                      backgroundColor: const Color.fromARGB(141, 255, 215, 105),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.progressTitleOpponent,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.progressMessageOpponent,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: LinearPercentIndicator(
                      //width: MediaQuery.of(context).size.width * 0.9,
                      animation: true,
                      lineHeight: 25.0,
                      animationDuration: 1000,
                      animateFromLastPercent: true,
                      percent: widget.percentOpponent,
                      barRadius: const Radius.circular(20.0),
                      progressColor: const Color.fromRGBO(255, 212, 96, 1),
                      backgroundColor: const Color.fromARGB(141, 255, 215, 105),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.chatVisible,
              child: Align(
                alignment: Alignment.topLeft,
                child: Stack(
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      margin: EdgeInsets.only(
                          left: 40,
                          top: MediaQuery.of(context).size.height * 0.11),
                      child: Image.asset(
                        'assets/pics/tamgiac.png',
                        color: const Color.fromARGB(218, 0, 0, 0),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            right: 30,
                            left: 30,
                            top: MediaQuery.of(context).size.height * 0.11 +
                                14.7),
                        // ignore: sort_child_properties_last
                        child: Text(
                          widget.messgae,
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(218, 0, 0, 0),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
