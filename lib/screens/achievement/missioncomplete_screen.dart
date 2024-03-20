import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class MissionCompleteScreen extends StatelessWidget {
  const MissionCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // GIF background
          Positioned.fill(
            child: Image.asset(
              'assets/animPics/cele_3.gif',
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "You received the badge",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/pics/achi1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Text(
                  "Legend",
                  style: TextStyle(
                    fontFamily: 'CustomProFont2',
                    color: Colors.white,
                    fontSize: 70,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Congratulations, you've earned 20 coins!",
                  style: GoogleFonts.roboto(
                    color: const Color.fromARGB(255, 255, 213, 96),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width - 60,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 132, 53, 13),
                          blurRadius: 0,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: button1v1,
                      child: const Text(
                        'GOT IT',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
