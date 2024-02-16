import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinktank_mobile/models/logininfo.dart';

class SharedPreferencesHelper {
  static const String loginInfoKey = 'loginInfo';

  static Future<void> saveAccount(LoginInfo account) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountJson = jsonEncode(account.toJson());
    prefs.setString(loginInfoKey, accountJson);
  }

  static Future<LoginInfo?> getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountJson = prefs.getString(loginInfoKey);

    if (accountJson != null) {
      Map<String, dynamic> accountMap = jsonDecode(accountJson);
      return LoginInfo.fromJson(accountMap);
    } else {
      return null;
    }
  }

  static Future<void> removeAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(loginInfoKey);
  }
}
