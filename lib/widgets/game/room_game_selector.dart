import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/models/game.dart';

class RoomGameSelector extends StatefulWidget {
  const RoomGameSelector({
    super.key,
    required this.gameSelector,
    required this.onSelectGame,
    required this.isSelected,
  });

  final Game gameSelector;
  final void Function() onSelectGame;
  final bool isSelected;

  @override
  State<RoomGameSelector> createState() => _RoomGameSelectorState();
}

class _RoomGameSelectorState extends State<RoomGameSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              widget.onSelectGame();
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.gameSelector.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 71, 71, 71).withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: widget.isSelected
                      ? Color.fromARGB(255, 240, 122, 63)
                      : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 120,
            child: Text(
              widget.gameSelector.name,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
