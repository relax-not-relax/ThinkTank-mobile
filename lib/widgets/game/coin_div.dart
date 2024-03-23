import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinDiv extends StatelessWidget {
  const CoinDiv({
    super.key,
    required this.amount,
    required this.color,
  });

  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/pics/TTcoin.png",
          width: 20,
          height: 20,
        ),
        const SizedBox(
          width: 7,
        ),
        Text(
          amount,
          style: GoogleFonts.roboto(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
