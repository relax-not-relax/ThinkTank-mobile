import 'package:thinktank_mobile/models/accountinrank.dart';

class GameLeaderboardResponse {
  const GameLeaderboardResponse({
    required this.accounts,
    required this.totalNumberOfRecords,
  });

  final List<AccountInRank> accounts;
  final int totalNumberOfRecords;
}
