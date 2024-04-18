import 'package:thinktank_mobile/models/analysis_group.dart';

class AnalysisGroupAverage {
  const AnalysisGroupAverage({
    required this.userId,
    required this.currentLevel,
    required this.analysisAverageScoreByGroupLevelResponses,
  });

  final int userId;
  final int currentLevel;
  final List<AnalysisGroup> analysisAverageScoreByGroupLevelResponses;

  factory AnalysisGroupAverage.fromJson(Map<String, dynamic> json) {
    return AnalysisGroupAverage(
      userId: json['userId'] as int,
      currentLevel: json['currentLevel'] as int,
      analysisAverageScoreByGroupLevelResponses:
          (json['analysisAverageScoreByGroupLevelResponses'] as List<dynamic>)
              .map((analysis) => AnalysisGroup.fromJson(analysis))
              .toList(),
    );
  }
}
