class FlipCardGame {
  final String hiddenCardpath = 'assets/pics/flipHidden_test.png';
  List<String>? gameImg;
  List<String>? duplicatedCardList;

  final List<String> cards_list = [
    "assets/pics/flip_1_test.png",
    "assets/pics/flip_2_test.png",
    "assets/pics/flip_3_test.png",
  ];

  List<bool> matchedCards = List.filled(6, false);

  List<Map<int, String>> matchCheck = [];

  final int cardCount = 6;

  void initGame() {
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
    duplicatedCardList = List.from(cards_list)..addAll(cards_list);
    duplicatedCardList!.shuffle();
  }
}
