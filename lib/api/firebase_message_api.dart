import 'package:firebase_database/firebase_database.dart';
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
    print('Token:');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  void initNoticationItems(void Function() pushNotification) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      pushNotification();
    });
  }

  Future<String?> getToken() async {
    final FCMToken = await _firebaseMessage.getToken();
    return FCMToken;
  }
}

class FirebaseRealTime {
  static final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref();
  static void setOnline(int id, bool value) {
    _databaseReference.child('online').child(id.toString()).set(value);
  }
}
