import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/data/data.dart';

class RoomInstructionScreen extends StatelessWidget {
  const RoomInstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Text(
                    'ROOM RULES',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'ButtonCustomFont',
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 10
                        ..color = Color.fromARGB(255, 255, 213, 96),
                    ),
                  ),
                  // Lớp văn bản chính
                  const Text(
                    'ROOM RULES',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'ButtonCustomFont',
                      color: Color.fromARGB(255, 240, 122, 63),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 28,
              child: Text(
                "The Room Party will include 3 games: Flip Card, Music Password, and Images Walkthrough. Players can find rooms using the room ID provided by friends, family, etc., to join the shared playroom and compete together in one of the 3 games with questions provided by ThinkTank. Players can also create their own playroom and send the entry code to other players. Let's compete and see who is the \"memory genius\" in this gathering.",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: games.sublist(0, 3).map((game) {
                    return Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                game.imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
