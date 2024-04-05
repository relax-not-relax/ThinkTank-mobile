import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/accountincontest.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/screens/contest/contest_menu.dart';
import 'package:thinktank_mobile/widgets/game/coin_div.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class FinalResultScreen extends StatefulWidget {
  const FinalResultScreen({
    super.key,
    required this.points,
    required this.gameId,
    required this.totalCoin,
    required this.contestId,
    required this.status,
  });

  final int points;
  final String status;
  final int gameId;
  final int totalCoin;
  final int? contestId;

  @override
  State<FinalResultScreen> createState() => _FinalResultScreenState();
}

class _FinalResultScreenState extends State<FinalResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
          vertical: 50,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage((widget.status == 'win')
                  ? 'assets/pics/winbg.png'
                  : (widget.status == 'lose')
                      ? 'assets/pics/losebg.png'
                      : 'assets/pics/drawbg.png'),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width * 0.7,
              right: 0,
              child: CoinDiv(
                amount: widget.totalCoin.toString(),
                color: Colors.white,
                size: 30,
                textSize: 18,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    (widget.status == 'win')
                        ? 'assets/pics/cup.png'
                        : (widget.status == 'lose')
                            ? 'assets/pics/cry.png'
                            : 'assets/pics/draw.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                Center(
                  child: (widget.status == 'win')
                      ? const Text(
                          "WINNER",
                          style: TextStyle(
                            fontFamily: 'CustomProFont',
                            fontSize: 60,
                            color: Color.fromARGB(255, 255, 213, 96),
                          ),
                        )
                      : (widget.status == 'lose')
                          ? const Text(
                              "LOSER",
                              style: TextStyle(
                                fontFamily: 'CustomProFont',
                                fontSize: 60,
                                color: Color.fromARGB(255, 17, 23, 32),
                              ),
                            )
                          : const Text(
                              "DRAW",
                              style: TextStyle(
                                fontFamily: 'CustomProFont',
                                fontSize: 60,
                                color: Color.fromRGBO(40, 52, 68, 1),
                              ),
                            ),
                ),
                Visibility(
                  visible: widget.status == 'win',
                  child: Center(
                    child: Text(
                      '${widget.points} Points',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.status == 'win',
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: widget.status == 'win',
                  child: Center(
                    child: CoinDiv(
                      amount: widget.contestId != null
                          ? "+ ${widget.points ~/ 10}"
                          : "+ 20",
                      color: Colors.white,
                      size: 25,
                      textSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Align(
                alignment: Alignment.bottomCenter,
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
                      if (widget.contestId != null) {
                        Contest contest =
                            (await SharedPreferencesHelper.getContests())
                                .singleWhere((element) =>
                                    element.id == widget.contestId);
                        AccountInContest? accountInContest =
                            await ContestsAPI.checkAccountInContest(contest.id);
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContestMenuScreen(
                                      contest: contest,
                                      accountInContest: accountInContest,
                                    )),
                            (route) => false);
                      }
                    },
                    style: widget.status == 'win'
                        ? buttonWinVer2(context)
                        : widget.status == 'lose'
                            ? buttonLoseVer2(context)
                            : buttonDraw(context),
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
    );
  }
}
