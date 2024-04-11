class FindAnonymousAsset {
  final int id;
  final String description;
  final int numberOfDescription;
  final String imgPath;
  final int topicId;

  FindAnonymousAsset(
      {required this.id,
      required this.description,
      required this.numberOfDescription,
      required this.imgPath,
      required this.topicId});

  factory FindAnonymousAsset.fromJson(Map<String, dynamic> json) {
    return FindAnonymousAsset(
        topicId: json['topicId'] as int,
        id: json['id'] as int,
        description: json['description'] as String,
        numberOfDescription: json['numberOfDescription'] as int,
        imgPath: json['imgPath'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'numberOfDescription': numberOfDescription,
      'imgPath': imgPath,
      'topicId': topicId
    };
  }
}
