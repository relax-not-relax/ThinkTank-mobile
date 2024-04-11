class IconServer {
  const IconServer({
    required this.id,
    required this.name,
    required this.avatar,
    required this.price,
    required this.status,
  });

  final int id;
  final String name;
  final String avatar;
  final int price;
  final bool status;

  factory IconServer.fromJson(Map<String, dynamic> json) {
    return IconServer(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      price: json['price'] as int,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'price': price,
      'status': status,
    };
  }
}
