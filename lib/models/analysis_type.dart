class AnalysisType {
  const AnalysisType({
    required this.percentOfImagesMemory,
    required this.percentOfAudioMemory,
    required this.percentOfSequentialMemory,
  });

  final double percentOfImagesMemory;
  final double percentOfAudioMemory;
  final double percentOfSequentialMemory;

  factory AnalysisType.fromJson(Map<String, dynamic> json) {
    return AnalysisType(
      percentOfImagesMemory: double.parse(
        json['percentOfImagesMemory'].toString(),
      ),
      percentOfAudioMemory: double.parse(
        json['percentOfAudioMemory'].toString(),
      ),
      percentOfSequentialMemory: double.parse(
        json['percentOfSequentialMemory'].toString(),
      ),
    );
  }
}
