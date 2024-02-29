import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:unicons/unicons.dart';

class TGameAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TGameAppBar({
    super.key,
    required this.preferredHeight,
    required this.userAvatar,
    required this.remainingTime,
    required this.gameName,
  });

  final double preferredHeight;
  final String userAvatar;
  final Duration remainingTime;
  final String gameName;

  @override
  State<TGameAppBar> createState() => _TGameAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class _TGameAppBarState extends State<TGameAppBar> {
  Future displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 20.0,
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
              width: 200.0,
              height: 200.0,
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
              height: 7.0,
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
                },
                child: const Text(
                  "Continue the game",
                  style: TextStyle(
                    fontFamily: 'ButtonCustomFont',
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: () {},
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
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 10.0,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                        radius: 35, // Avatar radius
                        backgroundImage: NetworkImage(
                            widget.userAvatar), // Your avatar image URL here
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
                            Text(
                              widget.gameName,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
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
                        displayBottomSheet(context);
                      },
                      icon: const Icon(
                        UniconsLine.ellipsis_v,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
