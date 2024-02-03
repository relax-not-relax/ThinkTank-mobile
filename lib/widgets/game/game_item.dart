import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:thinktank_mobile/models/game.dart';
import 'package:unicons/unicons.dart';

class GameItem extends StatelessWidget {
  const GameItem({
    super.key,
    required this.game,
    // required this.onSelectGame,
    //required this.index,
  });

  final Game game;
  // final void Function(Game game) onSelectGame;
  //final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          //color: Colors.orange,
          width: 220,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(game.imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 15.0,
          ),
          height: 195,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            color: game.color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    game.name,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    width: 200.0,
                    child: Text(
                      game.description,
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 13.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      game.type.length,
                      (index) {
                        return Row(
                          children: [
                            const Icon(
                              UniconsLine.check,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              game.type[index],
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
