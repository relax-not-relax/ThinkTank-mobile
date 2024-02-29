import 'package:flutter/material.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/widgets/appbar/game_appbar.dart';

class FlipCardGamePlay extends StatefulWidget {
  const FlipCardGamePlay({
    super.key,
    required this.maxTime,
    required this.account,
    required this.gameName,
  });

  final Duration maxTime;
  final Account account;
  final String gameName;

  @override
  State<FlipCardGamePlay> createState() => _FlipCardGamePlayState();
}

class _FlipCardGamePlayState extends State<FlipCardGamePlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.19,
        userAvatar: widget.account.avatar!,
        maxTime: widget.maxTime,
        gameName: widget.gameName,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 240, 199),
        ),
      ),
    );
  }
}
