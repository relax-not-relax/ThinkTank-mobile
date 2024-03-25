import 'dart:convert';

class Contest {
  int id;
  String name;
  String thumbnail;
  String startTime;
  String endTime;
  bool status;
  int gameId;
  int playTime;
  String gameName;
  int amoutPlayer;
  int coinBetting;
  List<AssetOfContest> assetOfContests;

  Contest({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.gameId,
    required this.playTime,
    required this.gameName,
    required this.amoutPlayer,
    required this.coinBetting,
    required this.assetOfContests,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      gameId: json['gameId'],
      playTime: json['playTime'],
      gameName: json['gameName'],
      amoutPlayer: json['amoutPlayer'],
      coinBetting: json['coinBetting'],
      assetOfContests: List<AssetOfContest>.from(
          json['assetOfContests'].map((x) => AssetOfContest.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'gameId': gameId,
      'playTime': playTime,
      'gameName': gameName,
      'amoutPlayer': amoutPlayer,
      'coinBetting': coinBetting,
      'assetOfContests':
          List<dynamic>.from(assetOfContests.map((x) => x.toJson())),
    };
  }
}

class AssetOfContest {
  int id;
  String value;
  int contestId;
  String nameOfContest;
  String type;

  AssetOfContest({
    required this.id,
    required this.value,
    required this.contestId,
    required this.nameOfContest,
    required this.type,
  });

  factory AssetOfContest.fromJson(Map<String, dynamic> json) {
    return AssetOfContest(
      id: json['id'],
      value: json['value'],
      contestId: json['contestId'],
      nameOfContest: json['nameOfContest'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'contestId': contestId,
      'nameOfContest': nameOfContest,
      'type': type,
    };
  }
}
