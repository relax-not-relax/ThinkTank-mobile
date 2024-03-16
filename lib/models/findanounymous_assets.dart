class FindAnonymousAsset {
  final int id;
  final String description;
  final int numberOfDescription;
  final String imgPath;

  FindAnonymousAsset(
      {required this.id,
      required this.description,
      required this.numberOfDescription,
      required this.imgPath});

  factory FindAnonymousAsset.fromJson(Map<String, dynamic> json) {
    return FindAnonymousAsset(
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
      'imgPath': imgPath
    };
  }
}
