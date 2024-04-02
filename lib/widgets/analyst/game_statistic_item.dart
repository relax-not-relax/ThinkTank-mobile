import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/models/game.dart';

class GameStatisticItem extends StatelessWidget {
  const GameStatisticItem({
    super.key,
    required this.game,
    required this.openStatistic,
  });

  final Game game;
  final void Function() openStatistic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openStatistic,
      child: Container(
        width: 220,
        height: 150,
        child: Stack(
          children: [
            Container(
              width: 220,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(game.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
              ),
            ),
            Container(
              width: 220,
              height: 150,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
                color: Color.fromARGB(101, 0, 0, 0),
              ),
            ),
            Container(
              width: 220,
              height: 150,
              child: Center(
                child: Text(
                  game.name,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
