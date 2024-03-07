import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/screens/game/game_menu.dart';
import 'package:thinktank_mobile/screens/notification/notiscreen.dart';
import 'package:thinktank_mobile/widgets/appbar/appbar.dart';
import 'package:thinktank_mobile/widgets/game/game_item.dart';

final PageController _pageController = PageController();
late List<Widget> _pages;
int _activePage = 0;
Timer? timer;

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key, required this.account});

  final Account account;
  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  void startTimer() {
    int _currentPage;
    _currentPage = 0;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
    _pageController.addListener(() {
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.page!.toInt() == contest.length - 1) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  void selectGame(BuildContext context, Game game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameMenuScreen(
          game: game,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pages = List.generate(
      contest.length,
      (index) {
        return Container(
          height: 210,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(contest[index]),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        );
      },
    );
    Future.delayed(
      Duration(seconds: 3),
      () {
        startTimer();
      },
    );
  }

  void openNotification(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotiScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TAppBar(
        onSelectNotification: () => openNotification(context),
        urlAvt: widget.account.avatar ?? '',
        fullname: widget.account.fullName,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pics/main_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          addAutomaticKeepAlives: true,
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
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
              height: 370,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return GameItem(
                      game: games[index],
                      onSelectGame: (game) {
                        selectGame(context, game);
                      },
                    );
                  },
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
                        "Memory Contest",
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
                      margin: const EdgeInsets.fromLTRB(14, 0, 14, 30),
                      child: SizedBox(
                        width: 383.0,
                        child: Text(
                          "Exciting competitions to challenge yourself against opponents in memory recall. This is an engaging arena to accelerate on the journey to becoming a “Memory master”.",
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
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 20),
              child: Stack(
                children: [
                  SizedBox(
                    height: 210,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: contest.length,
                      onPageChanged: (value) {
                        setState(() {
                          _activePage = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _pages[index];
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          _pages.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3,
                            ),
                            child: InkWell(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(microseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: _activePage == index
                                    ? Colors.black
                                    : const Color.fromARGB(255, 217, 217, 217),
                              ),
                            ),
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
    );
  }
}
