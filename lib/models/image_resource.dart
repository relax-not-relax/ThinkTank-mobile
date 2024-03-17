class ImageResource {
  const ImageResource({
    required this.id,
    required this.value,
  });

  final int id;
  final String value;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
    };
  }

  factory ImageResource.fromJson(Map<String, dynamic> json) {
    return ImageResource(
      id: json['id'],
      value: json['value'],
    );
  }
}
