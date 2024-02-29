import 'dart:async';

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
  Timer? timer;
  late Duration remainingTime;

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        final newTime = remainingTime - const Duration(milliseconds: 500);
        if (newTime.isNegative) {
          timer!.cancel();
        } else {
          remainingTime = newTime;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      remainingTime = widget.maxTime;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TGameAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.19,
        userAvatar: widget.account.avatar!,
        remainingTime: remainingTime,
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
