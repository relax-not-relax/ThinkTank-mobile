class IconApp {
  const IconApp({
    required this.id,
    required this.isAvailable,
    required this.accountId,
    required this.userName,
    required this.iconAvatar,
    required this.iconName,
  });

  final int id;
  final bool isAvailable;
  final int accountId;
  final String userName;
  final String iconAvatar;
  final String iconName;

  factory IconApp.fromJson(Map<String, dynamic> json) {
    return IconApp(
      id: json['id'] as int,
      isAvailable: json['isAvailable'] as bool,
      accountId: json['accountId'] as int,
      userName: json['userName'] as String,
      iconAvatar: json['iconAvatar'] as String,
      iconName: json['iconName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isAvailable': isAvailable,
      'accountId': accountId,
      'userName': userName,
      'iconAvatar': iconAvatar,
      'iconName': iconName,
    };
  }
}
