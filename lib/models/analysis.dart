class Analysis {
  const Analysis({
    required this.endTime,
    required this.value,
  });

  final DateTime endTime;
  final double value;

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      endTime: DateTime.parse(json['endTime']),
      value: double.parse(json['value'].toString()),
    );
  }
}
