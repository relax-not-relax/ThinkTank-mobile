class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.avatar,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.status,
  });

  final int? id;
  final String? avatar;
  final String? title;
  final String? description;
  final String? dateTime;
  final bool? status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'title': title,
        'description': description,
        'dateTime': dateTime,
        'status': status,
      };

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['id'],
        avatar: json['avatar'],
        title: json['title'],
        description: json['description'],
        dateTime: json['dateTime'],
        status: json['status'],
      );

  @override
  String toString() {
    return 'NotificationItem{imgUrl: $avatar, title: $title, description: $description, time: $dateTime, status: $status}';
  }
}
