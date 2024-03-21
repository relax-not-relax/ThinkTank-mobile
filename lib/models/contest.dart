class Contest {
  Contest({
    required this.id,
    required this.thumbnail,
    required this.startTime,
    required this.endTime,
    required this.coinBetting,
    required this.name,
    required this.gameName,
  });

  final int id;
  final String thumbnail;
  final String startTime;
  final String endTime;
  final int coinBetting;
  final String name;
  final String gameName;
}
