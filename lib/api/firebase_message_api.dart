import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseMessageAPI {
  final _firebaseMessage = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await _firebaseMessage.requestPermission();
    final FCMToken = await _firebaseMessage.getToken();
    print('Token: $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<String?> getToken() async {
    final FCMToken = await _firebaseMessage.getToken();
    return FCMToken;
  }
}
