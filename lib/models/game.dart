import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';

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
