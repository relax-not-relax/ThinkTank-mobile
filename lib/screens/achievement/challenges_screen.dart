import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thinktank_mobile/api/account_api.dart';
import 'package:thinktank_mobile/api/challenges_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/achievement.dart';
import 'package:thinktank_mobile/screens/achievement/missioncomplete_screen.dart';

class CustomTabIndicator extends Decoration {
  final BoxPainter _painter;

  CustomTabIndicator({required Color color, required double width})
      : _painter = _CustomPainter(color, width);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _painter;
  }
}

class _CustomPainter extends BoxPainter {
  final Paint _paint;
  final double width;

  _CustomPainter(Color color, this.width)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Offset circleOffset = offset +
        Offset(configuration.size!.width / 2 - width / 2,
            configuration.size!.height - 2.0);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            circleOffset.dx,
            circleOffset.dy,
            width,
            2.0,
          ),
          Radius.zero,
        ),
        _paint);
  }
}

class ChallengesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChallengesScreenState();
  }
}

class ChallengesScreenState extends State<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late TabController _tabController;
  List<Challenge> list = [];
  late Future<void> _getChallenges;
  Account? account = null;
  late Future _initAccount;
  int coin = 0;
  bool? isReceive;

  Future<dynamic> getAccount() async {
    dynamic result = await ApiAccount.getAccountById();
    if (result is Account) {
      return result;
    }
  }

  Future<void> getChallenges() async {
    list = await ApiChallenges.getChallenges();
    if (mounted) {
      setState(() {
        list;
      });
      if (list.where((element) => element.status == null).toList().isNotEmpty) {
        await SharedPreferencesHelper.saveCheckMisson(false);
        isReceive = await SharedPreferencesHelper.getCheckMission();
        setState(() {
          isReceive;
        });
      } else {
        isReceive = await SharedPreferencesHelper.getCheckMission();
        setState(() {
          isReceive;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getChallenges = getChallenges();
    _getChallenges.then((value) => {
          print(isReceive.toString() + "check"),
        });
    _initAccount = getAccount();
    _initAccount.then((value) {
      if (mounted) {
        setState(() {
          account = value;
          coin = account!.coin!;
        });
      }
    });
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Color> backgroundColors = [
    const Color.fromRGBO(250, 205, 67, 1),
    const Color.fromRGBO(189, 155, 255, 1),
    const Color.fromRGBO(255, 176, 176, 1),
    const Color.fromRGBO(219, 255, 191, 1),
    const Color.fromRGBO(118, 195, 223, 1),
    const Color.fromRGBO(155, 85, 154, 1),
    const Color.fromRGBO(248, 171, 127, 1),
    const Color.fromRGBO(203, 91, 91, 1),
    const Color.fromRGBO(146, 166, 250, 1),
    const Color.fromRGBO(89, 205, 209, 1)
  ];
  List<Color> shadowColors = [
    const Color.fromRGBO(235, 165, 0, 1),
    const Color.fromRGBO(152, 102, 250, 1),
    const Color.fromRGBO(255, 122, 122, 1),
    const Color.fromRGBO(186, 255, 133, 1),
    const Color.fromRGBO(89, 177, 209, 1),
    const Color.fromRGBO(137, 52, 136, 1),
    const Color.fromRGBO(255, 140, 75, 1),
    const Color.fromRGBO(175, 48, 48, 1),
    const Color.fromRGBO(114, 135, 225, 1),
    const Color.fromARGB(255, 68, 190, 194),
  ];

  void receive(Challenge mission) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MissionCompleteScreen(
            challenge: mission,
            isCompleted: isReceive!,
          );
        },
      ),
      (route) => false,
    );
  }

  Future<void> completeMission() async {
    setState(() {
      isReceive = true;
    });
    await SharedPreferencesHelper.saveCheckMisson(isReceive!);
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MissionCompleteScreen(isCompleted: isReceive!);
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: account != null
          ? AchievementAppBar(
              coins: coin,
              progress: list
                  .where((element) =>
                      ((element.completedLevel == null)
                          ? 0
                          : element.completedLevel! /
                              element.completedMilestone) ==
                      1)
                  .length,
              appBarHeight: MediaQuery.of(context).size.height * 0.45,
              isValid: isReceive != null ? isReceive! : false,
              getBadges: completeMission,
            )
          : AchievementAppBar(
              coins: 0,
              progress: list
                  .where((element) =>
                      ((element.completedLevel == null)
                          ? 0
                          : element.completedLevel! /
                              element.completedMilestone) ==
                      1)
                  .length,
              appBarHeight: MediaQuery.of(context).size.height * 0.45,
              isValid: isReceive != null ? isReceive! : false,
              getBadges: completeMission,
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
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              dividerColor: const Color.fromRGBO(116, 116, 116, 1),
              labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(
                  color: Color.fromRGBO(116, 116, 116, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              dividerHeight: 2,
              indicatorColor: Colors.white,
              indicator: CustomTabIndicator(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width / 2),
              tabs: const [
                Tab(text: "Missions"),
                Tab(text: "Badges"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(116, 116, 116, 1),
                            width: 0.8,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: list
                              .map(
                                (e) => ItemAchieve(
                                  imgLink: e.missionsImg,
                                  backgroundColor:
                                      backgroundColors[list.indexOf(e)],
                                  shadowColor: shadowColors[list.indexOf(e)],
                                  title: e.name,
                                  description: e.description,
                                  progress: (e.completedLevel == null)
                                      ? 0
                                      : e.completedLevel!,
                                  total: e.completedMilestone,
                                  received:
                                      (e.status == null) ? false : e.status!,
                                  getBadges: () {
                                    receive(e);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(116, 116, 116, 1),
                            width: 0.8,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: list
                              .where((element) => (element.status == null)
                                  ? false
                                  : element.status!)
                              .map((e) => ItemBadge(
                                  imgLink: e.avatar,
                                  title: e.name,
                                  time: e.completedDate.toString(),
                                  active: ((e.completedLevel == null)
                                              ? 0
                                              : e.completedLevel)! /
                                          e.completedMilestone ==
                                      1,
                                  borderBottom: list
                                          .where((element) =>
                                              element.status == true)
                                          .toList()
                                          .indexOf(e) !=
                                      list
                                              .where((element) =>
                                                  element.status == true)
                                              .toList()
                                              .length -
                                          1))
                              .toList(),
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

class ItemAchieve extends StatelessWidget {
  const ItemAchieve({
    super.key,
    required this.imgLink,
    required this.backgroundColor,
    required this.shadowColor,
    required this.title,
    required this.description,
    required this.progress,
    required this.total,
    required this.received,
    required this.getBadges,
  });
  final String imgLink;
  final Color backgroundColor;
  final Color shadowColor;
  final String title;
  final String description;
  final int progress;
  final int total;
  final bool received;
  final void Function() getBadges;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Container(
      height: 150,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          ColorFiltered(
            colorFilter: (progress / total != 1)
                ? const ColorFilter.mode(
                    Color.fromARGB(172, 0, 0, 0),
                    BlendMode.hue,
                  )
                : const ColorFilter.mode(
                    Color.fromARGB(0, 255, 255, 255),
                    BlendMode.hue,
                  ),
            child: Container(
              height: 100,
              width: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.network(imgLink),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                (progress / total != 1)
                    ? Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        child: Stack(
                          children: [
                            LinearPercentIndicator(
                              animation: true,
                              lineHeight: 25.0,
                              animationDuration: 1000,
                              animateFromLastPercent: true,
                              percent: (progress / total < 0)
                                  ? 0
                                  : ((progress / total > 1)
                                      ? 1
                                      : progress / total),
                              barRadius: const Radius.circular(10.0),
                              progressColor:
                                  const Color.fromRGBO(255, 199, 0, 1),
                              backgroundColor:
                                  const Color.fromRGBO(41, 41, 41, 1),
                            ),
                            SizedBox(
                              height: 25,
                              child: Center(
                                child: Text(
                                  (progress / total < 0)
                                      ? '0/$total'
                                      : '$progress/$total',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Visibility(
                        visible: true,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: !received
                              ? InkWell(
                                  onTap: getBadges,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    height: 30,
                                    width: 150,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 199, 0, 1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Receive reward',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  margin:
                                      const EdgeInsets.only(left: 20, top: 10),
                                  height: 30,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Received reward',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 41, 41, 41),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ItemBadge extends StatelessWidget {
  const ItemBadge({
    super.key,
    required this.imgLink,
    required this.title,
    required this.time,
    required this.active,
    required this.borderBottom,
  });
  final String imgLink;
  final String title;
  final String time;
  final bool active;
  final bool borderBottom;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    final DateTime parsedTime = DateTime.parse(time);

    // Format the DateTime object to "January 2024" style
    final String formattedTime = DateFormat('MMMM yyyy').format(parsedTime);

    return Container(
      height: 130,
      padding: const EdgeInsets.all(15),
      decoration: borderBottom
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(116, 116, 116, 1),
                  width: 0.8,
                ),
              ),
            )
          : null,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 80,
            width: 80,
            padding: const EdgeInsets.all(0),
            child: !active
                ? ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 0, 0, 0),
                      BlendMode.hue,
                    ),
                    child: Image.network(
                      imgLink,
                    ),
                  )
                : Image.network(
                    imgLink,
                  ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AchievementAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AchievementAppBar({
    super.key,
    required this.coins,
    required this.progress,
    required this.appBarHeight,
    required this.isValid,
    required this.getBadges,
  });
  final int coins;
  final int progress;
  final double appBarHeight;
  final bool isValid;
  final void Function() getBadges;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/pics/achi_bg.png'),
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: const Text(
                  'Your memory treasure chest has',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 55,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/pics/coin.png',
                        height: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 40,
                            ),
                            child: Text(
                              '$coins ThinkTank coins',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
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
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.58),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Complete 10 missions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Complete 10 missions to become “The Master of Memory” ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/pics/logoBage.png',
                              height: 50,
                            ),
                            Expanded(
                              child: Center(
                                child: progress != 10
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14.0),
                                        child: LinearPercentIndicator(
                                          animation: true,
                                          lineHeight: 25.0,
                                          animationDuration: 1000,
                                          animateFromLastPercent: true,
                                          percent: progress / 10,
                                          barRadius:
                                              const Radius.circular(10.0),
                                          progressColor: const Color.fromRGBO(
                                              255, 212, 96, 1),
                                          backgroundColor: const Color.fromRGBO(
                                              0, 0, 0, 0.26),
                                          center: Text(
                                            '$progress/10',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Visibility(
                                        visible: true,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: !isValid
                                              ? InkWell(
                                                  onTap: getBadges,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20, top: 10),
                                                    height: 30,
                                                    width: 150,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          255, 199, 0, 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Receive reward',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20, top: 10),
                                                  height: 30,
                                                  width: 150,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Received reward',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 41, 41, 41),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
