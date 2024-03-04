class Friendship {
  int id;
  bool? status;
  int? accountId1;
  int? accountId2;
  String? userName1;
  String? avatar1;
  String? userName2;
  String? avatar2;

  Friendship({
    required this.id,
    required this.status,
    required this.accountId1,
    required this.accountId2,
    required this.userName1,
    required this.avatar1,
    required this.userName2,
    required this.avatar2,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(
      id: json['id'] ?? 0,
      status: json['status'] ?? false,
      accountId1: json['accountId1'] ?? 0,
      accountId2: json['accountId2'] ?? 0,
      userName1: json['userName1'] ?? '',
      avatar1: json['avatar1'] ?? '',
      userName2: json['userName2'] ?? '',
      avatar2: json['avatar2'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'accountId1': accountId1,
      'accountId2': accountId2,
      'userName1': userName1,
      'avatar1': avatar1,
      'userName2': userName2,
      'avatar2': avatar2,
    };
  }
}
