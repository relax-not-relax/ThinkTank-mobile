class AccountInRoom {
  AccountInRoom({
    required this.id,
    required this.isAdmin,
    required this.accountId,
    this.username,
    required this.roomId,
    this.completedTime,
    required this.duration,
    required this.mark,
    required this.pieceOfInformation,
  });

  final int id;
  final bool isAdmin;
  final int accountId;
  String? username;
  final int roomId;
  String? completedTime;
  final double duration;
  final int mark;
  final int pieceOfInformation;

  factory AccountInRoom.fromJson(Map<String, dynamic> json) {
    return AccountInRoom(
      id: json['id'] as int,
      isAdmin: json['isAdmin'] as bool,
      accountId: json['accountId'] as int,
      username: null,
      roomId: json['roomId'] as int,
      completedTime: null,
      duration: double.parse(json['duration'].toString()),
      mark: json['mark'] as int,
      pieceOfInformation: json['pieceOfInformation'] as int,
    );
  }
}
