import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/api/notification_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/models/notification_item.dart';
import 'package:thinktank_mobile/screens/friend/friend_screen.dart';
import 'package:thinktank_mobile/screens/game/game_menu.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/notification/notiscreen.dart';
import 'package:thinktank_mobile/widgets/appbar/appbar.dart';
import 'package:thinktank_mobile/widgets/game/contest_thumbnail.dart';
import 'package:thinktank_mobile/widgets/game/game_item.dart';

final PageController _pageController = PageController();
late List<Widget> _pages;
int _activePage = 0;
Timer? timer;

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  //final Account account;
  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  Account? account = null;
  late Future _initAccount;
  late Future _getContests;
  List<Contest> contests = [];

  void startTimer() {
    int _currentPage;
    _currentPage = 0;
    _pageController.addListener(() {
      if (mounted)
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

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer!.cancel();
    }
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

  late int amount = 0;
  late Future<List<NotificationItem>> notifications =
      SharedPreferencesHelper.getNotifications();

  void pushNotification() {
    if (mounted)
      setState(() {
        amount++;
      });
  }

  @override
  void initState() {
    super.initState();
    _initAccount = getAccount();
    _initAccount.then((value) {
      setState(() {
        account = value;
      });
    });
    _getContests = getContests();
    _getContests.then((value) => {
          setState(() {
            contests = value;
            print(contests);
          })
        });
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
    FirebaseMessageAPI().initNoticationItems(pushNotification);
    updateNotifications();
  }

  Future<void> updateNotifications() async {
    List<NotificationItem> notifications =
        await ApiNotification.getNotifications();
    int notiAmountNotRead = notifications
        .where((notification) => notification.status == false)
        .length;
    if (mounted)
      setState(() {
        amount = notiAmountNotRead;
      });
    SharedPreferencesHelper.saveNotifications(notifications);
  }

  void openNotification(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotiScreen(),
      ),
    ).then(
      (value) async {
        List<NotificationItem> notifications =
            await ApiNotification.getNotifications();
        int notiAmountNotRead = notifications
            .where((notification) => notification.status == false)
            .length;
        if (mounted)
          setState(() {
            amount = notiAmountNotRead;
          });
        SharedPreferencesHelper.saveNotifications(notifications);
      },
    );
  }

  Future<Account?> getAccount() async {
    return await SharedPreferencesHelper.getInfo();
  }

  Future<List<Contest>> getContests() async {
    return await SharedPreferencesHelper.getContests();
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TAppBar(
        onSelectNotification: () => openNotification(context),
        account: account,
        notiAmount: amount,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const HomeScreen(
                                      inputScreen: FriendScreen(),
                                      screenIndex: 4);
                                },
                              ),
                            );
                          },
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
                        width: MediaQuery.of(context).size.width - 50,
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
                        width: MediaQuery.of(context).size.width - 50,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: contests.map(
                    (contest) {
                      return ContestThumbnail(
                        contest: contest,
                      );
                    },
                  ).toList(),
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
