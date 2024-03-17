import 'dart:math';

import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';

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

  Future initGame(int level) async {
    List<String> listTmp = await SharedPreferencesHelper.getImageResource();
    listTmp.shuffle();
    print(listTmp.toString() + "abc");

    if (level == 1) {
      cardCount = 6;
      time = 3.15 * cardCount;
      await SharedPreferencesHelper.saveFlipCardTime(time);
      for (int i = 0; i < cardCount / 2; i++) {
        cards_list.add(listTmp[i]);
        print(listTmp[i] + "abc");
      }
      matchedCards = List.filled(cardCount, false);
      print(time);
    } else if (level >= 2) {
      time = await SharedPreferencesHelper.getFLipCardTime();

      c = level % 10 <= 1 ? (level ~/ 10) : (level ~/ 10 + 1);
      double levelConst = (3.15 - 0.48) / pow(2, c) / 10;
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

      double levelVar = time - levelConst;
      time = cardCount * levelVar;
      print(time);
      await SharedPreferencesHelper.saveFlipCardTime(time);
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
