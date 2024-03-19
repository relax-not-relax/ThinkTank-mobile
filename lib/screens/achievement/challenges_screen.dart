import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thinktank_mobile/api/challenges_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/achievement.dart';

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

  Future<void> getChallenges() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    list = await ApiChallenges.getChallenges(account!.id, account.accessToken!);
    if (mounted) {
      setState(() {
        list;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getChallenges = getChallenges();
    _getChallenges.then((value) => {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AvhievementAppBar(
          coins: 2998,
          progress: list
              .where((element) =>
                  ((element.completedLevel == null)
                      ? 0
                      : element.completedLevel! / element.completedMilestone) ==
                  1)
              .length),
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
                                  recived:
                                      (e.status == null) ? false : e.status!,
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
                                  borderBottom:
                                      list.indexOf(e) != list.length - 1))
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
    required this.recived,
  });
  final String imgLink;
  final Color backgroundColor;
  final Color shadowColor;
  final String title;
  final String description;
  final int progress;
  final int total;
  final bool recived;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
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
                        fontSize: 25,
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
                              percent: progress / total,
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
                                  '$progress/$total',
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
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            height: 30,
                            width: 150,
                            decoration: BoxDecoration(
                              color: (!recived)
                                  ? const Color.fromRGBO(255, 199, 0, 1)
                                  : Colors.grey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                (!recived)
                                    ? 'Receive reward'
                                    : 'Received reward',
                                style: TextStyle(
                                  color:
                                      (recived) ? Colors.black : Colors.white,
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
                        fontSize: 25,
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
                      time,
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

class AvhievementAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AvhievementAppBar({
    super.key,
    required this.coins,
    required this.progress,
  });
  final int coins;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/pics/achi_bg.png'), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
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
                width: MediaQuery.of(context).size.width - 10,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.58),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/pics/logoBage.png',
                          height: 60,
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: Stack(
                                children: [
                                  LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: 25.0,
                                    animationDuration: 1000,
                                    animateFromLastPercent: true,
                                    percent: progress / 10,
                                    barRadius: const Radius.circular(10.0),
                                    progressColor:
                                        const Color.fromRGBO(255, 212, 96, 1),
                                    backgroundColor:
                                        const Color.fromRGBO(0, 0, 0, 0.26),
                                  ),
                                  SizedBox(
                                    height: 25,
                                    child: Center(
                                      child: Text(
                                        '$progress/10',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromRGBO(171, 171, 171, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(360);
}