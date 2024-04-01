import 'package:synchronized/synchronized.dart';

class LockRefreshTokenManager {
  static final LockRefreshTokenManager _instance =
      LockRefreshTokenManager._internal();
  factory LockRefreshTokenManager() => _instance;

  LockRefreshTokenManager._internal();

  final Lock _lock = Lock();

  Lock get lock => _lock;
}
