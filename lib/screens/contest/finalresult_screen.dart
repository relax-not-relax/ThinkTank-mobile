import 'package:flutter/material.dart';

class FinalResultScreen extends StatefulWidget {
  const FinalResultScreen({
    super.key,
    required this.points,
    required this.haveTime,
    this.time,
    required this.isWin,
    required this.gameId,
    required this.totalCoin,
  });

  final int points;
  final bool haveTime;
  final double? time;
  final bool isWin;
  final int gameId;
  final int totalCoin;

  @override
  State<FinalResultScreen> createState() => _FinalResultScreenState();
}

class _FinalResultScreenState extends State<FinalResultScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
