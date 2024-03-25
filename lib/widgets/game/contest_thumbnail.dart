import 'package:flutter/material.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/screens/contest/contest_menu.dart';

class ContestThumbnail extends StatelessWidget {
  const ContestThumbnail({
    super.key,
    required this.contest,
  });

  final Contest contest;

  void openContest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ContestMenuScreen(contest: contest);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openContest(context);
      },
      child: Hero(
        tag: contest.id,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          width: MediaQuery.of(context).size.width - 40,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(contest.thumbnail),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
