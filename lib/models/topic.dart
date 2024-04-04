class Topic {
  const Topic({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: int.parse(json["id"].toString()),
      name: json["name"].toString(),
    );
  }
}
