import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:thinktank_mobile/models/battleinfo.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseMessageAPI {
  final _firebaseMessage = FirebaseMessaging.instance;
  static bool isRegisBattle = false;
  bool isFindBattle = false;
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

  //void Function(AccountBattle) playBattle
  static void initBattleMessage(void Function() findOpponet) async {
    if (!isRegisBattle) {
      print("Dang ky!!");
      isRegisBattle = true;
      var onMessgae =
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          print("ghep do");
          if (message.notification!.title == 'Battle') {
            print("ghp luon");
            findOpponet();
          }
        }
      });
    }
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
