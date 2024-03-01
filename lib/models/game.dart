import 'package:flutter/material.dart';

class Game {
  const Game({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.type,
    required this.color,
  });

  final int id;
  final String imageUrl;
  final String name;
  final String description;
  final List<String> type;
  final Color color;
}

class GameInfo {
  static Game musicPassword = const Game(
    id: 2,
    imageUrl: "assets/pics/game_2.png",
    name: "Music Password",
    description:
        "Players will listen to a piece of music provided by the host to decipher the password for the house, enhancing their auditory memory skills.",
    type: ["Auditory memory", "Interactive memory", "Sensory memory"],
    color: Color.fromARGB(255, 245, 171, 43),
  );
}
