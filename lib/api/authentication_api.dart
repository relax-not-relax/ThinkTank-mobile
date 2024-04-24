import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:synchronized/synchronized.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/api/lock_manager.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';

class ApiAuthentication {
  static final Lock _lock = LockRefreshTokenManager().lock;
  static Future<bool> logOut() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (account == null) return false;
    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/${account.id}/token-revoke'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      await SharedPreferencesHelper.removeAllofLogout();
      FirebaseRealTime.cancleListenLogin();
      FirebaseRealTime.cancleListenOnline();
      FirebaseRealTime.setLogin(account.id, false);
      FirebaseRealTime.setOnline(account.id, false);
      return true;
    } else {
      print("logout loi");
      return false;
    }
  }

  static Future<bool> forgotpassword(String username, String email) async {
    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/forgotten-password?Email=$email&Username=$username'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Account?> loginWithGoogle(
      GoogleSignInAccount? googleSignInAccount) async {
    try {
      if (googleSignInAccount != null) {
        String? fcmToken = await FirebaseMessageAPI().getToken();
        print("fcm:" + (fcmToken ?? "khong co"));
        Map<String, String> loginData = {
          "googleId": googleSignInAccount.id,
          "fcm": fcmToken ?? "",
          "avatar": googleSignInAccount.photoUrl ?? "",
          "email": googleSignInAccount.email,
          "fullName": googleSignInAccount.displayName ?? "Anonymous"
        };

        String jsonBody = jsonEncode(loginData);

        print(jsonBody);

        final response = await http.post(
          Uri.parse(
              'https://thinktank-sep490.azurewebsites.net/api/accounts/google-authentication'),
          headers: {'Content-Type': 'application/json'},
          body: jsonBody,
        );

        print("Robinho " + jsonBody);
        print(response.statusCode);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          FirebaseRealTime.setOnline(Account.fromJson(jsonData).id, true);
          FirebaseRealTime.listenOnline(Account.fromJson(jsonData).id);
          FirebaseRealTime.setLogin(Account.fromJson(jsonData).id, true);
          FirebaseRealTime.listenlogin(Account.fromJson(jsonData).id);
          return Account.fromJson(jsonData);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<bool> checkOnline(int accountId) async {
    bool result = false;
    FirebaseDatabase.instance
        .ref()
        .child('online')
        .child(accountId.toString())
        .set(false);
    await Future.delayed(Duration(seconds: 2));
    StreamSubscription stream;
    stream = FirebaseDatabase.instance
        .ref()
        .child('online')
        .child(accountId.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.value.toString() == 'true') {
        result = true;
      } else {
        result = false;
      }
    });
    await Future.delayed(Duration(seconds: 2));
    stream.cancel();
    return result;
  }

  static Future<Account?> reLogin() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    if (account == null) return null;

    Map<String, String?> data = {
      "accessToken": account.accessToken,
      "refreshToken": account.refreshToken,
    };
    String jsonBody = jsonEncode(data);
    print(jsonBody);
    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/token-verification'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      await SharedPreferencesHelper.saveInfo(Account.fromJson(jsonData));
      FirebaseRealTime.setOnline(Account.fromJson(jsonData).id, true);
      FirebaseRealTime.listenOnline(Account.fromJson(jsonData).id);
      FirebaseRealTime.setLogin(Account.fromJson(jsonData).id, true);
      FirebaseRealTime.listenlogin(account.id);
      return Account.fromJson(jsonData);
    } else if (response.statusCode == 400 || response.body != null) {
      final jsonData2 = json.decode(response.body);
      if (jsonData2['error'].toString() == "Access Token is not expried") {
        await SharedPreferencesHelper.saveInfo(account);
        FirebaseRealTime.setOnline(account.id, true);
        FirebaseRealTime.listenOnline(account.id);
        FirebaseRealTime.setLogin(account.id, true);
        FirebaseRealTime.listenlogin(account.id);
        return account;
      } else {
        await SharedPreferencesHelper.removeInfo();
        return null;
      }
    } else {
      await SharedPreferencesHelper.removeInfo();
      return null;
    }
  }

  static Future<int> checkLogin(String? username, String? password,
      String? fcmToken, String? googleId) async {
    final response;
    if (googleId != null) {
      response = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accounts/authentication-checking?googleId=$googleId'),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.get(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accounts/authentication-checking?userName=$username&password=$password'),
        headers: {'Content-Type': 'application/json'},
      );
    }
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      FirebaseRealTime.setLogin(Account.fromJson(jsonData).id, false);
      return Account.fromJson(jsonData).id;
    } else {
      final jsonData = json.decode(response.body);
      try {
        if (jsonData['error'].toString() == 'Your account is block') {
          return -1;
        }
      } catch (e) {
        return 0;
      }
      return 0;
    }
  }

  static Future<Account?> login(
      String username, String password, String fcmToken) async {
    Map<String, String> loginData = {
      "userName": username,
      "password": password,
      "fcm": fcmToken
    };
    String jsonBody = jsonEncode(loginData);

    final response = await http.post(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/accounts/authentication-player'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      FirebaseRealTime.setOnline(Account.fromJson(jsonData).id, true);
      FirebaseRealTime.listenOnline(Account.fromJson(jsonData).id);
      FirebaseRealTime.setLogin(Account.fromJson(jsonData).id, true);
      FirebaseRealTime.listenlogin(Account.fromJson(jsonData).id);
      return Account.fromJson(jsonData);
    } else {
      print(response.body);
      return null;
    }
  }

  static Future<http.Response> register(
      String fullname, String username, String email, String password) async {
    Map<String, String?> data = {
      "fullName": fullname,
      "userName": username,
      "email": email,
      "password": password,
      "fcm": null,
      "googleId": null
    };
    String jsonBody = jsonEncode(data);
    final response = await http.post(
      Uri.parse('https://thinktank-sep490.azurewebsites.net/api/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );
    return response;
  }

  static Future<Account?> refreshToken() async {
    return await _lock.synchronized(() async {
      Account? account = await SharedPreferencesHelper.getInfo();
      if (account == null) {
        return null;
      }

      Map<String, String?> data = {
        "accessToken": account.accessToken,
        "refreshToken": account.refreshToken,
      };
      String jsonBody = jsonEncode(data);
      final response = await http.post(
        Uri.parse(
            'https://thinktank-sep490.azurewebsites.net/api/accounts/token-verification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        await SharedPreferencesHelper.saveInfo(Account.fromJson(jsonData));
        return Account.fromJson(jsonData);
      } else if (response.statusCode == 400) {
        final jsonData2 = json.decode(response.body);
        if (jsonData2['error'].toString() == "Access Token is not expried") {
          return account;
        } else {
          return null;
        }
      } else {
        return null;
      }
    });
  }
}
