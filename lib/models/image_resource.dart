class ImageResource {
  const ImageResource(
      {required this.topicId, required this.value, required this.id});

  final int topicId;
  final String value;
  final int id;

  Map<String, dynamic> toJson() {
    return {'topicId': topicId, 'value': value, 'id': id};
  }

  factory ImageResource.fromJson(Map<String, dynamic> json) {
    return ImageResource(
      id: json['id'] as int,
      topicId: json['topicId'] as int,
      value: json['value'],
    );
  }
}
