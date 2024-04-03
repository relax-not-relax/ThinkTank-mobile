class BattleInfo {
  String username;
  String avatar;
  int coin;

  BattleInfo({
    required this.username,
    required this.avatar,
    required this.coin,
  });

  factory BattleInfo.fromJson(Map<String, dynamic> json) {
    return BattleInfo(
      username: json['Username'] ?? "",
      avatar: json['Avatar'] ?? "",
      coin: json['Coin'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Username'] = this.username;
    data['Avatar'] = this.avatar;
    data['Coin'] = this.coin;
    return data;
  }
}
