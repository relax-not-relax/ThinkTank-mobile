class MusicPasswordSource {
  const MusicPasswordSource(
      {required this.soundLink, required this.answer, required this.topicId});

  final String answer;
  final String soundLink;
  final int topicId;

  Map<String, dynamic> toJson() {
    return {'answer': answer, 'soundLink': soundLink, 'topicId': topicId};
  }

  factory MusicPasswordSource.fromJson(Map<String, dynamic> json) {
    return MusicPasswordSource(
      answer: json['answer'],
      soundLink: json['soundLink'],
      topicId: json['topicId'] as int,
    );
  }

  @override
  String toString() {
    return 'MusicPasswordSource(answer: $answer, soundLink: $soundLink, topicId: $topicId)';
  }
}
