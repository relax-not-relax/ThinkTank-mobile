class ImageResource {
  const ImageResource({
    required this.topicId,
    required this.value,
  });

  final int topicId;
  final String value;

  Map<String, dynamic> toJson() {
    return {
      'topicId': topicId,
      'value': value,
    };
  }

  factory ImageResource.fromJson(Map<String, dynamic> json) {
    return ImageResource(
      topicId: json['topicId'] as int,
      value: json['value'],
    );
  }
}
