class AccountInRank {
  int accountId;
  String fullName;
  String avatar;
  int mark;
  int rank;

  AccountInRank({
    required this.accountId,
    required this.fullName,
    required this.avatar,
    required this.mark,
    required this.rank,
  });

  factory AccountInRank.fromJson(Map<String, dynamic> json) {
    return AccountInRank(
      accountId: json['accountId'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      mark: json['mark'],
      rank: json['rank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'fullName': fullName,
      'avatar': avatar,
      'mark': mark,
      'rank': rank,
    };
  }
}
