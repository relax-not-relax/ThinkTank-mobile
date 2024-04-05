class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.avatar,
    required this.title,
    required this.description,
    required this.dateNotification,
    required this.status,
  });

  final int? id;
  final String? avatar;
  final String? title;
  final String? description;
  final String? dateNotification;
  final bool? status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'title': title,
        'description': description,
        'dateNotification': dateNotification,
        'status': status,
      };

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['id'],
        avatar: json['avatar'],
        title: json['title'],
        description: json['description'],
        dateNotification: json['dateNotification'],
        status: json['status'],
      );

  @override
  String toString() {
    return 'NotificationItem{imgUrl: $avatar, title: $title, description: $description, time: $dateNotification, status: $status}';
  }
}
