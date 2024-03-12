import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinktank_mobile/screens/findanonymous/cardprovider.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:thinktank_mobile/widgets/others/textstroke.dart';

class AnonymousCard extends StatefulWidget {
  const AnonymousCard(
      {super.key,
      required this.avtlink,
      required this.color,
      required this.isFront});
  final String avtlink;
  final Color color;
  final bool isFront;

  @override
  State<AnonymousCard> createState() => _AnonymousCardState();
}

class _AnonymousCardState extends State<AnonymousCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.isFront ? buildFrontCard() : buildCard();

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final miliseconds = provider.isDragging ? 0 : 300;
          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            duration: Duration(milliseconds: miliseconds),
            curve: Curves.easeInOut,
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: buildCard(),
          );
        }),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
      );

  Widget buildCard() => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: widget.color),
      );
}

class FindAnonymousGame extends StatefulWidget {
  const FindAnonymousGame({super.key, required this.avt});
  final String avt;

  @override
  State<StatefulWidget> createState() {
    return FindAnonymousGameState();
  }
}

class FindAnonymousGameState extends State<FindAnonymousGame>
    with TickerProviderStateMixin {
  bool roundVisible = true;
  late Animation<double> _opacityAnimation;
  late AnimationController _controller;
  bool scriptVisibile = false;
  bool findVisible = false;

  bool showBG = true;
  List<Color> lisColor = [Colors.black, Colors.amber, Colors.blue, Colors.pink];

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            setState(() {
              lisColor = lisColor.reversed.toList();
              roundVisible = false;
              scriptVisibile = true;
              findVisible = true;
            });
          },
        );
      }
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    provider.urlImages = lisColor;
    final urlImages = provider.urlImages;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.26,
        userAvatar: widget.avt,
        remainingTime: Duration(seconds: 1),
        gameName: 'game name',
        progressTitle: 'Chance',
        progressMessage: '5/5',
        percent: 5 / 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: const AssetImage(
              'assets/pics/bganonymous.png',
            ),
            opacity: showBG ? 1 : 0,
          ),
          color: const Color.fromRGBO(255, 240, 199, 1),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Visibility(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          children: urlImages
                              .map(
                                (e) => AnonymousCard(
                                  avtlink: '',
                                  color: e,
                                  isFront: urlImages.last == e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: roundVisible,
              child: Container(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(153, 0, 0, 0)),
              ),
            ),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Visibility(
                visible: roundVisible,
                child: Center(
                    child: TextWidget(
                  'Round 1',
                  fontFamily: 'ButtonCustomFont',
                  fontSize: 70,
                  strokeColor: const Color.fromRGBO(255, 212, 96, 1),
                  strokeWidth: 20,
                  color: const Color.fromRGBO(240, 123, 63, 1),
                )),
              ),
            ),
            Visibility(
              visible: scriptVisibile,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(0, 40, 30, 30),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Text(
                        "- A girl: long hair, blue asda asdui iouagsd iubasd eyes!\n_A boy: black hair, blue eyes!\n_A boy: black hair, blue eyes!\n_A boy: black hair, blue eyes!\n_A boy: black hair, blue eyes!\n_A boy: black hair, blue eyes!\n_A boy: black hair, blue eyes!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: findVisible,
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 76,
                    width: 336,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 7,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            findVisible = false;
                            scriptVisibile = false;
                            showBG = false;
                          });
                        },
                        style: button1v1,
                        child: const Text(
                          'FIND',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
