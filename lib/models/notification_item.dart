class NotificationItem {
  const NotificationItem({
    required this.imgUrl,
    required this.title,
    required this.description,
    required this.time,
  });

  final String imgUrl;
  final String title;
  final String description;
  final DateTime time;
}
