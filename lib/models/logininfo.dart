class LoginInfo {
  final String username;
  final String password;

  LoginInfo({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      username: json['username'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'LoginInfo{username: $username, password: $password}';
  }
}
