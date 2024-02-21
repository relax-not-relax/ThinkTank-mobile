import 'dart:convert';

class Account {
  final int id;
  final String code;
  final String fullName;
  final String userName;
  final String email;
  final String? gender;
  final String? dateOfBirth;
  final String? avatar;
  final int? coin;
  final bool? isOnline;
  final String refreshToken;
  final String? fcm;
  final bool status;
  final String googleId;
  final String accessToken;
  final String version;

  Account({
    required this.id,
    required this.code,
    required this.fullName,
    required this.userName,
    required this.email,
    this.gender,
    this.dateOfBirth,
    this.avatar,
    this.coin,
    this.isOnline,
    required this.refreshToken,
    this.fcm,
    required this.status,
    required this.googleId,
    required this.accessToken,
    required this.version,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      code: json['code'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      avatar: json['avatar'],
      coin: json['coin'],
      isOnline: json['isOnline'],
      refreshToken: json['refreshToken'],
      fcm: json['fcm'],
      status: json['status'],
      googleId: json['googleId'],
      accessToken: json['accessToken'],
      version: json['version'],
    );
  }

  @override
  String toString() {
    return 'Account{id: $id, code: $code, fullName: $fullName, userName: $userName, email: $email, gender: $gender, dateOfBirth: $dateOfBirth, avatar: $avatar, coin: $coin, isOnline: $isOnline, refreshToken: $refreshToken, fcm: $fcm, status: $status, googleId: $googleId, accessToken: $accessToken, version: $version}';
  }
}