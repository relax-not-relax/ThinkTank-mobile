import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/friends_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountbattle.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/screens/game/battle_main_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/challenge_appbar.dart';
import 'package:thinktank_mobile/widgets/game/room_game_selector.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class ChallengePlayerScreen extends StatefulWidget {
  const ChallengePlayerScreen({
    super.key,
    required this.competitorId,
  });

  final int competitorId;

  @override
  State<ChallengePlayerScreen> createState() => _ChallengePlayerScreenState();
}

class _ChallengePlayerScreenState extends State<ChallengePlayerScreen> {
  Game? selectedGame = null;
  bool isSelecting = false;

  void onSelectGame(Game game) async {
    setState(() {
      selectedGame = game;
      isSelecting = true;
    });

    setState(() {
      isSelecting = false;
    });
  }

  void _showReject(BuildContext context) {
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
                  'assets/pics/accOragne.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Can't play",
                  style: TextStyle(
                      color: Color.fromRGBO(234, 84, 85, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Your coin is not enough to play',
                  style: TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> onBattle() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    dynamic result =
        await ApiFriends.challengeFriend(selectedGame!.id, widget.competitorId);
    if (account!.coin! < 20) {
      _showReject(context);
      return;
    }
    if (result is AccountBattle) {
      result.accountId = 0;
      result.avatar = null;
      result.coin = 0;
      result.username = null;
      switch (selectedGame!.id) {
        case 4:
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BattleMainScreen(
                account: account!,
                gameId: 4,
                competitor: result,
                isWithFriend: true,
              ),
            ),
          );
          break;
        case 2:
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BattleMainScreen(
                account: account!,
                gameId: 2,
                competitor: result,
                isWithFriend: true,
              ),
            ),
          );
          break;
      }
    } else {
      // ignore: use_build_context_synchronously
      _showResizableDialogError(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: TChallengeAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 14,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Text(
                "Select a game to challenge your friend",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  "Challenge your friends to see who has the better memory.",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      onSelectGame(games[1]);
                    },
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(games[1].imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 71, 71, 71)
                                .withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: selectedGame == games[1]
                              ? Color.fromARGB(255, 240, 122, 63)
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onSelectGame(games[2]);
                    },
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(games[2].imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 71, 71, 71)
                                .withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                        border: Border.all(
                          color: selectedGame == games[2]
                              ? Color.fromARGB(255, 240, 122, 63)
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 200,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width - 60,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 132, 53, 13),
                        blurRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      onBattle();
                    },
                    style: button1v1,
                    child: const Text(
                      'BATTLE',
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
            )
          ],
        ),
      ),
    );
  }
}

void _showResizableDialogError(BuildContext context, String message) {
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
                'assets/pics/error.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Oh no!',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  message,
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
