import 'dart:convert';

class AccountInContest {
  int id;
  int contestId;
  int accountId;
  String userName;
  String contestName;
  DateTime? completedTime;
  double duration;
  int mark;
  int prize;
  String avatar;

  AccountInContest(
      {this.id = 0,
      this.contestId = 0,
      this.accountId = 0,
      this.userName = "",
      this.contestName = "",
      required this.completedTime,
      this.duration = 0,
      this.mark = 0,
      this.prize = 0,
      required this.avatar});

  factory AccountInContest.fromJson(Map<String, dynamic> json) {
    return AccountInContest(
        id: json['id'] ?? 0,
        contestId: json['contestId'] ?? 0,
        accountId: json['accountId'] ?? 0,
        userName: json['userName'] ?? "",
        contestName: json['contestName'] ?? "",
        completedTime: DateTime.tryParse(json['completedTime'] ?? ""),
        duration: json['duration'] ?? 0,
        mark: json['mark'] ?? 0,
        prize: json['prize'] ?? 0,
        avatar: json['avatar'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "contestId": contestId,
      "accountId": accountId,
      "userName": userName,
      "contestName": contestName,
      "completedTime": completedTime?.toIso8601String(),
      "duration": duration,
      "mark": mark,
      "prize": prize,
      "avatar": avatar
    };
  }
}
