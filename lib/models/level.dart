import 'package:thinktank_mobile/models/game.dart';

class Level {
  const Level({
    required this.totalLevel,
    required this.levelCompleted,
    required this.game,
  });

  final List<int> totalLevel;
  final int levelCompleted;
  final Game game;
}
