import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';

class FlipCardGame {
  final String hiddenCardpath = 'assets/pics/flipHidden_test.png';
  List<String>? gameImg;
  List<String>? duplicatedCardList;

  final List<String> cards_list = [];

  List<bool> matchedCards = List.filled(6, false);

  List<Map<int, String>> matchCheck = [];

  final int cardCount = 6;

  Future initGame() async {
    List<String> listTmp = await SharedPreferencesHelper.getImageResource();
    listTmp.shuffle();
    cards_list.add(
        '/data/user/0/com.example.thinktank_mobile/app_flutter/image191.png');
    cards_list.add(
        '/data/user/0/com.example.thinktank_mobile/app_flutter/image157.png');
    cards_list.add(
        '/data/user/0/com.example.thinktank_mobile/app_flutter/image148.png');
    print(listTmp[0]);
    print(listTmp[1]);
    print(listTmp[2]);

    duplicatedCardList = List.from(cards_list)..addAll(cards_list);
    duplicatedCardList!.shuffle();
  }

  void initGameImg() {
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}
