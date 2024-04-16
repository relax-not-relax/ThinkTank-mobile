import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/challenges_api.dart';
import 'package:thinktank_mobile/models/achievement.dart';
import 'package:thinktank_mobile/screens/achievement/challenges_screen.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class MissionCompleteScreen extends StatefulWidget {
  const MissionCompleteScreen({super.key, required this.challenge});

  final Challenge challenge;

  @override
  State<MissionCompleteScreen> createState() => _MissionCompleteScreenState();
}

class _MissionCompleteScreenState extends State<MissionCompleteScreen> {
  bool isGot = false;
  bool isPending = true;
  List<Challenge> list = [];
  // late Future<void> _getBadges;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.challenge.missionsImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  widget.challenge.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'CustomProFont2',
                    color: Colors.white,
                    fontSize: 40,
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
                Stack(
                  children: [
                    Visibility(
                      visible: isPending,
                      child: SizedBox(
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
                            onPressed: () async {
                              setState(() {
                                isPending = false;
                                isGot = true;
                              });
                              list = await ApiChallenges.getBadges(
                                  widget.challenge.id);

                              if (list.isNotEmpty) {
                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeScreen(
                                          inputScreen: ChallengesScreen(),
                                          screenIndex: 3);
                                    },
                                  ),
                                  (route) => false,
                                );
                              }
                            },
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
                    ),
                    Visibility(
                      visible: isGot,
                      child: const Column(
                        children: [
                          CustomLoadingSpinner(color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
