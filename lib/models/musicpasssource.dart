class MusicPasswordSource {
  const MusicPasswordSource({
    required this.soundLink,
    required this.answer,
  });

  final String answer;
  final String soundLink;

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'soundLink': soundLink,
    };
  }

  factory MusicPasswordSource.fromJson(Map<String, dynamic> json) {
    return MusicPasswordSource(
      answer: json['answer'],
      soundLink: json['soundLink'],
    );
  }

  @override
  String toString() {
    return 'MusicPasswordSource(answer: $answer, soundLink: $soundLink)';
  }
}
