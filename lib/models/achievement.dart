import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';

class Challenge {
  final int id;
  final String name;
  final String avatar;
  final String description;
  final int completedMilestone;
  final String unit;
  final int? completedLevel;
  final bool? status;
  final DateTime? completedDate;
  final String missionsImg;

  Challenge({
    required this.id,
    required this.name,
    required this.avatar,
    required this.description,
    required this.completedMilestone,
    required this.unit,
    this.completedLevel,
    this.status,
    this.completedDate,
    required this.missionsImg,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      description: json['description'] as String,
      completedMilestone: json['completedMilestone'] as int,
      unit: json['unit'] as String,
      completedLevel: json['completedLevel'] as int?,
      status: json['status'] as bool?,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
      missionsImg: json['missionsImg'] as String,
    );
  }
}
