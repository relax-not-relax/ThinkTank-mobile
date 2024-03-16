import 'package:thinktank_mobile/screens/findanonymous/findanonymous_game.dart';

class FindAnonymous {
  const FindAnonymous({
    required this.level,
    required this.listAnswer,
    required this.time,
  });

  final int level;
  final List<AnswerAnonymous> listAnswer;
  final int time;
}
