import 'dart:math';

import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/contest.dart';

class FlipCardGame {
  final String hiddenCardpath = "assets/pics/flipHidden_test.png";
  List<String> gameImg = [];
  List<String>? duplicatedCardList;

  final List<String> cards_list = [];

  // List<bool> matchedCards = List.filled(6, false);
  List<bool> matchedCards = [];

  List<Map<int, String>> matchCheck = [];

  int cardCount = 6;
  int c = 0;
  double time = 0.0;

  Future<double> getTimeFlipcard(int level) async {
    if (level == 1) {
      cardCount = 6;
    }
    if (level >= 2 && level <= 5) {
      cardCount = 8;
    } else if (level >= 6 && level <= 10) {
      cardCount = 12;
    } else if (level >= 11 && level <= 20) {
      cardCount = 16;
    } else if (level >= 21 && level <= 30) {
      cardCount = 20;
    } else if (level >= 31 && level <= 40) {
      cardCount = 24;
    } else {
      cardCount = 28;
    }

    int c = (level % 10 <= 1) ? level ~/ 10 : ((level ~/ 10) + 1);
    if (level == 1) {
      return (3.15 * cardCount);
    } else {
      return (await getTimeFlipcard(level - 1) -
          (3.15 - 0.48) / pow(2, c) / 10 * cardCount);
    }
  }

  Future initGame(int level, int? contestId, int? topicId) async {
    if (contestId != null) {
      Contest contest = (await SharedPreferencesHelper.getContests())
          .firstWhere((element) => element.id == contestId);

      time = contest.playTime;
      List<AssetOfContest> assets =
          (await SharedPreferencesHelper.getAllContestAssets())
              .where((element) => element.contestId == contestId)
              .toList();
      for (var element in assets) {
        cards_list.add(element.value);
      }
      cards_list.shuffle();
      cardCount = cards_list.length * 2;
      matchedCards = List.filled(cardCount, false);
      duplicatedCardList = List.from(cards_list)..addAll(cards_list);
      duplicatedCardList!.shuffle();
    } else if (topicId != null) {
      time = 150;
      List<String> tmps =
          (await SharedPreferencesHelper.getImageResourceByTopicId(topicId));
      tmps.shuffle();
      cards_list.addAll(tmps.getRange(0, 10));
      cards_list.shuffle();
      cardCount = 20;
      matchedCards = List.filled(cardCount, false);
      duplicatedCardList = List.from(cards_list)..addAll(cards_list);
      duplicatedCardList!.shuffle();
    } else {
      List<String> listTmp =
          await SharedPreferencesHelper.getImageResourceByTopicId(39);
      listTmp.shuffle();
      print(listTmp.toString() + "abc");
      time = (await getTimeFlipcard(level));

      if (level == 1) {
        cardCount = 6;

        for (int i = 0; i < cardCount / 2; i++) {
          cards_list.add(listTmp[i]);
          print(listTmp[i] + "abc");
        }
        matchedCards = List.filled(cardCount, false);
      } else if (level >= 2) {
        if (level >= 2 && level <= 5) {
          cardCount = 8;
        } else if (level >= 6 && level <= 10) {
          cardCount = 12;
        } else if (level >= 11 && level <= 20) {
          cardCount = 16;
        } else if (level >= 21 && level <= 30) {
          cardCount = 20;
        } else if (level >= 31 && level <= 40) {
          cardCount = 24;
        } else {
          cardCount = 28;
        }

        for (int i = 0; i < cardCount / 2; i++) {
          cards_list.add(listTmp[i]);
          print(listTmp[i] + "abc");
        }
        matchedCards = List.filled(cardCount, false);
      }

      //gameImg = List.generate(cardCount, (index) => hiddenCardpath);
      duplicatedCardList = List.from(cards_list)..addAll(cards_list);
      duplicatedCardList!.shuffle();
    }
  }

  Future<List<String>> initGameImg(int level) async {
    List<String> listTmp = [];
    if (level == 1) {
      cardCount = 6;
    } else if (level >= 2) {
      if (level >= 2 && level <= 5) {
        cardCount = 8;
      } else if (level >= 6 && level <= 10) {
        cardCount = 12;
      } else if (level >= 11 && level <= 20) {
        cardCount = 16;
      } else if (level >= 21 && level <= 30) {
        cardCount = 20;
      } else if (level >= 31 && level <= 40) {
        cardCount = 24;
      } else {
        cardCount = 28;
      }
    }

    for (int i = 0; i < cardCount; i++) {
      listTmp.add("assets/pics/logo_2.png");
    }

    return listTmp;
  }
}
