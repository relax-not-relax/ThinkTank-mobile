import 'package:thinktank_mobile/models/topic.dart';

class GameOfServer {
  const GameOfServer({
    required this.id,
    required this.name,
    required this.amoutPlayer,
    required this.topics,
  });

  final int id;
  final String name;
  final int amoutPlayer;
  final List<Topic> topics;

  factory GameOfServer.fromJson(Map<String, dynamic> json) {
    return GameOfServer(
      id: int.parse(json["id"].toString()),
      name: json["name"].toString(),
      amoutPlayer: int.parse(json["amoutPlayer"].toString()),
      topics: (json['topics'] as List<dynamic>)
          .map((topicJson) => Topic.fromJson(topicJson))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Game{id: $id, name: $name, amoutPlayer: $amoutPlayer, topics: $topics}';
  }
}
