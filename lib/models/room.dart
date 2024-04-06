import 'package:thinktank_mobile/models/account_in_room.dart';

class Room {
  Room({
    required this.id,
    required this.name,
    required this.code,
    required this.amountPlayer,
    this.startTime,
    this.endTime,
    this.status,
    required this.topicId,
    required this.topicName,
    required this.gameName,
    required this.accountInRoomResponses,
  });

  final int id;
  final String name;
  final String code;
  final int amountPlayer;
  String? startTime;
  String? endTime;
  bool? status;
  final int topicId;
  final String topicName;
  final String gameName;
  final List<AccountInRoom> accountInRoomResponses;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      amountPlayer: json['amountPlayer'] as int,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      status: json['status'] as bool?,
      topicId: json['topicId'] as int,
      topicName: json['topicName'] as String,
      gameName: json['gameName'] as String,
      accountInRoomResponses: (json['accountInRoomResponses'] as List<dynamic>)
          .map((account) => AccountInRoom.fromJson(account))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Room: $id, Code: $code';
  }
}
