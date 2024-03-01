class ResourceVersion {
  int anonymousVersion;
  int flipCardAndImagesWalkthroughVersion;
  int musicPasswordVersion;
  int storyTellerVersion;

  ResourceVersion({
    required this.anonymousVersion,
    required this.flipCardAndImagesWalkthroughVersion,
    required this.musicPasswordVersion,
    required this.storyTellerVersion,
  });

  factory ResourceVersion.fromJson(Map<String, dynamic> json) {
    return ResourceVersion(
      anonymousVersion: json['anonymousVersion'] ?? 0,
      flipCardAndImagesWalkthroughVersion:
          json['flipCardAndImagesWalkthroughVersion'] ?? 0,
      musicPasswordVersion: json['musicPasswordVersion'] ?? 0,
      storyTellerVersion: json['storyTellerVersion'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anonymousVersion': anonymousVersion,
      'flipCardAndImagesWalkthroughVersion':
          flipCardAndImagesWalkthroughVersion,
      'musicPasswordVersion': musicPasswordVersion,
      'storyTellerVersion': storyTellerVersion,
    };
  }
}
