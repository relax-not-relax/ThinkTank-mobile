import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/screens/contest/instruction_screen.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/game/coin_div.dart';
import 'package:thinktank_mobile/widgets/game/memory_type.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:unicons/unicons.dart';

class ContestMenuScreen extends StatefulWidget {
  const ContestMenuScreen({
    super.key,
    required this.contest,
  });

  final Contest contest;

  @override
  State<ContestMenuScreen> createState() => _ContestMenuScreenState();
}

class _ContestMenuScreenState extends State<ContestMenuScreen> {
  late DateTime startContest;
  late DateTime endContest;
  late String formatStartDate;
  late String formatEndDate;

  bool isWaiting = false;
  bool isVisible = true;
  //late Future _waitingToJoin;

  @override
  void initState() {
    super.initState();
    startContest = DateTime.parse(widget.contest.startTime);
    endContest = DateTime.parse(widget.contest.endTime);
    formatStartDate = DateFormat('yMd').format(startContest);
    formatEndDate = DateFormat('yMd').format(endContest);
  }

  void waiting() {
    setState(() {
      isVisible = false;
      isWaiting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            Account? account = await SharedPreferencesHelper.getInfo();
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(
                  inputScreen: OptionScreen(),
                  screenIndex: 0,
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 30.0,
          color: Colors.white,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return InstructionScreen();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: const Color.fromARGB(255, 240, 122, 63),
            ),
            child: const Icon(
              UniconsLine.question_circle,
              size: 45.0,
              color: Colors.white,
            ),
          ),
        ],
        toolbarHeight: 90.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Hero(
              tag: widget.contest.id,
              child: Image.asset(
                widget.contest.thumbnail,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(0, 0, 0, 0),
                      Color.fromARGB(197, 0, 0, 0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.contest.name,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                const Shadow(
                                  offset: Offset(0, 5.0),
                                  blurRadius: 10.0,
                                  color: Color.fromARGB(172, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            spacing: 5.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: 3.0,
                            children: [
                              MemoryType(
                                type: widget.contest.gameName,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 231, 165),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: CoinDiv(
                                  amount: widget.contest.coinBetting.toString(),
                                  color: Color.fromARGB(255, 40, 52, 68),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 240, 122, 63),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  IconlyLight.time_circle,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  formatStartDate + " - " + formatEndDate,
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.89,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/pics/menu_bg.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: isVisible,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(183, 0, 0, 0),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  _showJoinDialog(
                                    context,
                                    widget.contest.coinBetting.toString(),
                                    waiting,
                                  );
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStatePropertyAll(
                                    Size(MediaQuery.of(context).size.width - 45,
                                        80.0),
                                  ),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                    Color.fromARGB(255, 234, 67, 53),
                                  ),
                                  side: const MaterialStatePropertyAll(
                                    BorderSide(
                                      color: Colors.white,
                                      width: 5,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "JOIN",
                                  style: TextStyle(
                                    fontFamily: 'ButtonCustomFont',
                                    fontSize: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(183, 0, 0, 0),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  fixedSize: MaterialStatePropertyAll(
                                    Size(MediaQuery.of(context).size.width - 45,
                                        80.0),
                                  ),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                    Color.fromARGB(255, 85, 125, 176),
                                  ),
                                  side: const MaterialStatePropertyAll(
                                    BorderSide(
                                      color: Colors.white,
                                      width: 5,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "LEADERBOARD",
                                  style: TextStyle(
                                    fontFamily: 'ButtonCustomFont',
                                    fontSize: 28,
                                    color: Colors.white,
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
              ),
            ),
            Visibility(
              visible: isWaiting,
              child: Positioned(
                top: MediaQuery.of(context).size.height * 0.7,
                left: 0,
                right: 0,
                child: const Column(
                  children: [
                    CustomLoadingSpinner(color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showJoinDialog(BuildContext context, String coin, Function accept) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Confirmation',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Join the contest with $coin ThinkTank coins?',
          style: GoogleFonts.roboto(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'No',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              accept();
              _closeDialog(context);

              // ignore: use_build_context_synchronously
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
