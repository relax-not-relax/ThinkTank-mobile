class AccountBattle {
  int accountId;
  String? avatar;
  int? coin;
  String roomId;
  String? username;

  AccountBattle({
    required this.accountId,
    this.avatar,
    this.coin,
    required this.roomId,
    this.username,
  });

  factory AccountBattle.fromJson(Map<String, dynamic> json) {
    return AccountBattle(
      accountId: json['accountId'] ?? 0,
      avatar: json['avatar'],
      coin: json['coin'],
      roomId: json['roomId'] ?? "",
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['avatar'] = this.avatar;
    data['coin'] = this.coin;
    data['roomId'] = this.roomId;
    data['username'] = this.username;
    return data;
  }
}
