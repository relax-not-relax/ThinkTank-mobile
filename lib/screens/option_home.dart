import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/widgets/game/game_item.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      addAutomaticKeepAlives: true,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
          width: double.infinity,
          height: 190.0,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/pics/bnn_opt.png"),
              fit: BoxFit.cover,
              alignment: Alignment(0, 0.2),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: const Color.fromARGB(255, 45, 64, 89),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.9),
                spreadRadius: 3,
                blurRadius: 9.4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 240.0,
                      child: Text(
                        'Play game together with your friends now!',
                        style: GoogleFonts.roboto(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    FilledButton(
                      style: const ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                          Size(129.0, 20.0),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 234, 84, 85),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Find Friends",
                        style: GoogleFonts.roboto(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 20, 14, 0),
                  child: Text(
                    "Memory Bootcamp",
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
                    width: 383.0,
                    child: Text(
                      "Mini-games designed to exercise and enhance your memory. Through challenging gameplay, push your memory skills to the limit.",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: games.length,
              itemBuilder: (context, index) {
                return GameItem(game: games[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
