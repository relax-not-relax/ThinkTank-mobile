import 'package:thinktank_mobile/models/account_in_room.dart';

class Room {
  Room({
    required this.id,
    required this.name,
    required this.code,
    required this.amountPlayer,
    this.startTime,
    this.endTime,
    required this.status,
    required this.topicId,
    required this.topicName,
    required this.gameName,
    required this.accountIn1Vs1Responses,
  });

  final int id;
  final String name;
  final String code;
  final int amountPlayer;
  String? startTime;
  String? endTime;
  final bool status;
  final int topicId;
  final String topicName;
  final String gameName;
  final List<AccountInRoom> accountIn1Vs1Responses;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      amountPlayer: json['amountPlayer'] as int,
      startTime: null,
      endTime: null,
      status: json['status'] as bool,
      topicId: json['topicId'] as int,
      topicName: json['topicName'] as String,
      gameName: json['gameName'] as String,
      accountIn1Vs1Responses: (json['accountIn1Vs1Responses'] as List<dynamic>)
          .map((account) => AccountInRoom.fromJson(account))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Room: $id, Code: $code';
  }
}
