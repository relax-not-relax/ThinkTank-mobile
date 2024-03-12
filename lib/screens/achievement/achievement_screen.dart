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

class AchivementScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AchievementScreenState();
  }
}

class AchievementScreenState extends State<AchivementScreen>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late TabController _tabController;
  List<Challenge> list = [];
  late Future<void> _getChallenges;

  Future<void> getChallenges() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    list = await ApiChallenges.getChallenges(account!.id, account.accessToken!);
    setState(() async {
      list;
    });
    print('messi' + list.length.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const AvhievementAppBar(),
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
                        child: const Column(
                          children: [
                            ItemAchieve(
                              imgLink: 'assets/pics/achi1.png',
                              backgroundColor: Color.fromRGBO(104, 162, 239, 1),
                              shadowColor: Color.fromRGBO(74, 109, 156, 1),
                              title: 'Legend',
                              description:
                                  'Achieve top 1 in single play mode 5 times',
                              progress: 1,
                              total: 1,
                              recived: false,
                              descriptionDone:
                                  'You achieved top 1 in single play mode 5 times',
                            ),
                            ItemAchieve(
                              imgLink: 'assets/pics/achi1.png',
                              backgroundColor: Color.fromRGBO(104, 162, 239, 1),
                              shadowColor: Color.fromRGBO(74, 109, 156, 1),
                              title: 'Legend',
                              description:
                                  'Achieve top 1 in single play mode 5 times',
                              progress: 1,
                              total: 1,
                              recived: true,
                              descriptionDone:
                                  'You achieved top 1 in single play mode 5 times',
                            ),
                            ItemAchieve(
                              imgLink: 'assets/pics/achi1.png',
                              backgroundColor: Color.fromRGBO(104, 162, 239, 1),
                              shadowColor: Color.fromRGBO(74, 109, 156, 1),
                              title: 'Legend',
                              description:
                                  'Achieve top 1 in single play mode 5 times',
                              progress: 2,
                              total: 3,
                              recived: true,
                              descriptionDone:
                                  'You achieved top 1 in single play mode 5 times',
                            ),
                          ],
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
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ItemBadge(
                              imgLink: 'assets/pics/badge1.png',
                              title: 'Legend',
                              time: 'January 2024',
                              active: true,
                              borderBottom: true,
                            ),
                            ItemBadge(
                              imgLink: 'assets/pics/badge2.png',
                              title: 'Fast and Furious',
                              time: 'January 2024',
                              active: false,
                              borderBottom: false,
                            )
                          ],
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
  const ItemAchieve(
      {super.key,
      required this.imgLink,
      required this.backgroundColor,
      required this.shadowColor,
      required this.title,
      required this.description,
      required this.progress,
      required this.total,
      required this.recived,
      required this.descriptionDone});
  final String imgLink;
  final Color backgroundColor;
  final Color shadowColor;
  final String title;
  final String description;
  final String descriptionDone;
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
                    Color.fromARGB(255, 0, 0, 0),
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
              child: Image.asset(imgLink),
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
                      (recived) ? descriptionDone : description,
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
                        margin: EdgeInsets.only(top: 10, left: 10),
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
                        visible: !recived,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
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
                                  color: Colors.black,
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
                    child: Image.asset(
                      imgLink,
                    ),
                  )
                : Image.asset(
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
  });

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
                          child: const Text(
                            '1234 ThinkTank coins',
                            style: TextStyle(
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
                                    percent: 4 / 10,
                                    barRadius: const Radius.circular(10.0),
                                    progressColor:
                                        const Color.fromRGBO(255, 212, 96, 1),
                                    backgroundColor:
                                        const Color.fromRGBO(0, 0, 0, 0.26),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                    child: Center(
                                      child: Text(
                                        '4/10',
                                        style: TextStyle(
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
