import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/widgets/game/coin_div.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class FinalResultScreen extends StatefulWidget {
  const FinalResultScreen({
    super.key,
    required this.points,
    required this.isWin,
    required this.gameId,
    required this.totalCoin,
  });

  final int points;

  final bool isWin;
  final int gameId;
  final int totalCoin;

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
              image: AssetImage(
                widget.isWin
                    ? 'assets/pics/winbg.png'
                    : 'assets/pics/losebg.png',
              ),
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
                    widget.isWin
                        ? 'assets/pics/cup.png'
                        : 'assets/pics/cry.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                Center(
                  child: widget.isWin
                      ? const Text(
                          "WINNER",
                          style: TextStyle(
                            fontFamily: 'CustomProFont',
                            fontSize: 60,
                            color: Color.fromARGB(255, 255, 213, 96),
                          ),
                        )
                      : const Text(
                          "LOSER",
                          style: TextStyle(
                            fontFamily: 'CustomProFont',
                            fontSize: 60,
                            color: Color.fromARGB(255, 17, 23, 32),
                          ),
                        ),
                ),
                Visibility(
                  visible: widget.isWin,
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
                  visible: widget.isWin,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: widget.isWin,
                  child: Center(
                    child: CoinDiv(
                      amount: "+ ${widget.points ~/ 10}",
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
                    onPressed: () {},
                    style: widget.isWin
                        ? buttonWinVer2(context)
                        : buttonLoseVer2(context),
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
