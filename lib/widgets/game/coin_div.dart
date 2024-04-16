import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinDiv extends StatelessWidget {
  const CoinDiv({
    super.key,
    required this.amount,
    required this.color,
    required this.size,
    required this.textSize,
  });

  final String amount;
  final Color color;
  final double size;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/pics/TTcoin.png",
          width: size,
          height: size,
        ),
        const SizedBox(
          width: 7,
        ),
        Text(
          amount,
          style: GoogleFonts.roboto(
            fontSize: textSize,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
