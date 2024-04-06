class AccountInRoom {
  AccountInRoom({
    required this.id,
    required this.isAdmin,
    required this.accountId,
    required this.username,
    required this.roomId,
    this.avatar,
    this.completedTime,
    required this.duration,
    required this.mark,
    required this.pieceOfInformation,
  });

  final int id;
  final bool isAdmin;
  final int accountId;
  final String username;
  final int roomId;
  String? avatar;
  String? completedTime;
  final double duration;
  final int mark;
  final int pieceOfInformation;

  factory AccountInRoom.fromJson(Map<String, dynamic> json) {
    return AccountInRoom(
      id: json['id'] as int,
      isAdmin: json['isAdmin'] as bool,
      accountId: json['accountId'] as int,
      username: json['username'] as String,
      roomId: json['roomId'] as int,
      avatar: json['avatar'] != null && json['avatar'] != ""
          ? json['avatar'] as String
          : "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
      completedTime: json['completedTime'] as String?,
      duration: double.parse(json['duration'].toString()),
      mark: json['mark'] as int,
      pieceOfInformation: json['pieceOfInformation'] as int,
    );
  }
}
