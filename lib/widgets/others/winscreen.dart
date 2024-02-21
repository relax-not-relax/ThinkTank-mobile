import 'package:flutter/material.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class WinScreen extends StatefulWidget {
  const WinScreen(
      {super.key, required this.points, required this.haveTime, this.time});
  final int points;
  final bool haveTime;
  final double? time;

  @override
  State<StatefulWidget> createState() {
    return WinScreenState();
  }
}

class WinScreenState extends State<WinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pics/winbg.png'),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/pics/cup.png',
                    width: 400,
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/pics/wintext.png',
                    width: 300,
                  ),
                ),
                Center(
                  child: Text(
                    '${widget.points} Points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.haveTime,
                  child: Center(
                    child: Text(
                      '${widget.time}s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
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
                      style: buttonWin,
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
          ],
        ),
      ),
    );
  }
}
