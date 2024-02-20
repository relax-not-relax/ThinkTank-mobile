import 'package:flutter/material.dart';
import 'package:thinktank_mobile/models/level.dart';
import 'package:thinktank_mobile/widgets/game/level_item.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key, required this.level});

  final Level level;

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 30.0,
          color: Colors.white,
        ),
        toolbarHeight: 90.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pics/level_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: widget.level.totalLevel.length,
          itemBuilder: (context, index) {
            return LevelItem(
              levelCompleted: widget.level.levelCompleted,
              levelNumber: widget.level.totalLevel[index],
            );
          },
        ),
      ),
    );
  }
}
