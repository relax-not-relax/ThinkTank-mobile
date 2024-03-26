import 'package:flutter/material.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/accountincontest.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/screens/contest/contest_menu.dart';

class ContestThumbnail extends StatelessWidget {
  const ContestThumbnail({
    super.key,
    required this.contest,
  });

  final Contest contest;

  void openContest(BuildContext context) async {
    AccountInContest? accountInContest =
        await ContestsAPI.checkAccountInContest(contest.id);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ContestMenuScreen(
            contest: contest,
            accountInContest: accountInContest,
          );
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
