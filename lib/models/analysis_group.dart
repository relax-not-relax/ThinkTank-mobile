class AnalysisGroup {
  const AnalysisGroup({
    required this.groupLevel,
    required this.averageOfGroup,
    required this.averageOfPlayer,
  });

  final String groupLevel;
  final double averageOfGroup;
  final double averageOfPlayer;

  factory AnalysisGroup.fromJson(Map<String, dynamic> json) {
    return AnalysisGroup(
      groupLevel: json['groupLevel'] as String,
      averageOfGroup: double.parse(json['averageOfGroup'].toString()),
      averageOfPlayer: double.parse(json['averageOfPlayer'].toString()),
    );
  }
}
