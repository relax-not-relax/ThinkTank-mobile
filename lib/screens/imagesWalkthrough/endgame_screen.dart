import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class EndGameScreen extends StatelessWidget {
  const EndGameScreen({
    super.key,
    required this.onContinue,
  });

  final void Function() onContinue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 320,
            width: 320,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/pics/walkthrough_lose.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              bottom: 30.0,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 76,
                width: 336,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 40, 52, 68),
                        blurRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: button1v1_2,
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
    );
  }
}
